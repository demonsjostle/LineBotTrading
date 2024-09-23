from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
import json

from django.http import HttpResponse, HttpResponseBadRequest, HttpResponseForbidden, HttpResponseServerError, JsonResponse, HttpResponseRedirect
from decouple import config

from rest_framework import generics
from .models import Notification
from store.models import Customer
from .serializers import NotificationSerializer, MessageSerializer

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone
from datetime import timedelta


# line
from linebot.v3 import (
    WebhookHandler
)
from linebot.v3.exceptions import (
    InvalidSignatureError
)
from linebot.v3.messaging import (
    Configuration,
    ApiClient,
    MessagingApi,
    ReplyMessageRequest,
    TextMessage,
    ImageMessage,
    VideoMessage,
    ImagemapMessage,
    ImagemapArea,
    URIImagemapAction,
    ImagemapBaseSize,
    MessageAction,
    QuickReply,
    QuickReplyItem,
    PostbackAction,
    PushMessageRequest,
    FlexMessage,
    FlexContainer

)
from linebot.v3.webhooks import (
    MessageEvent,
    PostbackEvent,
    TextMessageContent,

)
from .line_templates.flex_messages.send_expired_warning import send_expired_warning


ACCESS_TOKEN = config('LINE_ACCESS_TOKEN')
SECRET_TOKEN = config('LINE_SECRET_TOKEN')
configuration = Configuration(access_token=ACCESS_TOKEN)
handler = WebhookHandler(SECRET_TOKEN)
with ApiClient(configuration) as api_client:
    line_bot_api = MessagingApi(api_client)


@csrf_exempt
def index(request):
    if request.method == 'POST':
        signature = request.headers.get('X-Line-Signature')
        body = request.body.decode('utf-8')
        try:
            handler.handle(body, signature)
        except InvalidSignatureError:
            return HttpResponseBadRequest("Invalid signature. Please check your channel access token/channel secret.")

        return HttpResponse("OK")


@handler.add(MessageEvent, message=TextMessageContent)
def handle_text_message(event):

    # message_id = event.message.id
    # image_url = 'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8&w=1000&q=80'
    # image_message = ImageSendMessage(original_content_url=image_url, preview_image_url=image_url)
    # text_message = TextSendMessage(text="message")
    # # line_bot_api.reply_message(event.reply_token, [image_message, text_message, text_message])
    message = event.message.text

    response_message = TextMessage(
        text="คำถามนี้ต้องอาศัยความรู้เฉพาะทางซึ่งเกินความสามารถของน้องบอทในตอนนี้นะคะ \nทาง admin จะติดต่อกลับเพื่อสอบถามข้อมูลเพิ่มเติมและช่วยตอบคำถามให้ครบถ้วนค่ะ")

    if message == "#my_id":
        response_message = TextMessage(text=event.source.user_id)

    line_bot_api.reply_message(ReplyMessageRequest(
        replyToken=event.reply_token, messages=[response_message]))


class NotificationListCreateView(generics.ListCreateAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer


class NotificationDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer


class SendMessageAPIView(APIView):

    def post(self, request):
        # Parse the incoming data
        serializer = MessageSerializer(data=request.data)

        # Validate the data
        if serializer.is_valid():
            # Access the message
            request_message = serializer.validated_data

            # print(request_message["message"])
            # print(request_message["package"])

            customers = Customer.objects.all()
            if len(customers) >= 1:
                # customers_line_ids = [customer.line_user_id for customer in customers]
                for customer in customers:
                    if customer.expired_plan and customer.current_plan.name.lower() == request_message['package'].lower():
                        current_time = timezone.now()
                        three_days_later = current_time + timedelta(days=3)
                        # check not expired_plan
                        if not (current_time > customer.expired_plan):
                            mess = TextMessage(
                                text=f"{request_message['message']}")
                            line_bot_api.push_message(PushMessageRequest(
                                to=customer.line_user_id, messages=[mess]))

                            # Chek 3 days later
                            if customer.expired_plan <= three_days_later:
                                mess = FlexMessage(altText="learning&development", contents=FlexContainer.from_json(
                                    f'''{json.dumps(send_expired_warning(3), indent=4)}'''))
                                line_bot_api.push_message(PushMessageRequest(
                                    to=customer.line_user_id, messages=[mess]))

            return Response({"success": True, "message": request_message}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
