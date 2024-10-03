from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
import json
import re

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
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
import logging


# line
from linebot.v3 import (
    WebhookHandler
)
from linebot.v3.exceptions import (
    InvalidSignatureError,

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
    FlexContainer,
    ApiException,
    ErrorResponse

)
from linebot.v3.webhooks import (
    MessageEvent,
    PostbackEvent,
    TextMessageContent,

)

from .line_templates.flex_messages.send_expired_warning import send_expired_warning


# Configure the logger
logging.basicConfig(
    filename='line_bot_errors.log',  # Log file name
    level=logging.ERROR,             # Log level
    format='%(asctime)s - %(levelname)s - %(message)s'  # Log format
)


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
        # Template for the buy format message
        buy_format = """=== 🔔{header} ===
Symbol : {symbol}
Position : Buy 🟩
Entry Price : {entry_price}
TP : {tp}
SL : {sl}

Date 🗓️: {date}
Time 🕛: {time}
Win/Loss : {win_loss}
=====================
Trader : {trader_name}"""

        sell_format = """=== 🔔{header} ===
Symbol : {symbol}
Position : Sell 🟥
Entry Price : {entry_price}
TP : {tp}
SL : {sl}

Date 🗓️: {date}
Time 🕛: {time}
Win/Loss : {win_loss}
=====================
Trader : {trader_name}"""
        pending_format = """=== 🔔{header} ===
Symbol : {symbol}
Position : {position}
Pending Price : {pending_price}
TP : {tp}
SL : {sl}

Date 🗓️: {date}
Time 🕛: {time}
Win/Loss : {win_loss}
=====================
Trader : {trader_name}"""

        # Parse the incoming data
        serializer = MessageSerializer(data=request.data)
        print(request.data)
        # Validate the data
        if serializer.is_valid():
            # Access the message
            request_message = serializer.validated_data
            message_content = request_message['message']

            formatted_message = message_content.replace("\\n", "\n")
            # Extract data from the formatted message
            # Assuming the message is in a predefined format and we can extract the values based on known lines
            lines = formatted_message.split('\n')
            data = {}
            for line in lines:
                if ':' in line:
                    key, value = line.split(':', 1)
                    data[key.strip().lower()] = value.strip()

            # Select the correct format based on the position (buy/sell)
            if data.get('position', '').upper() == 'BUY':
                message_to_send = buy_format.format(
                    header=self.extract_header(formatted_message),
                    symbol=data.get('symbol', ''),
                    entry_price=data.get('entry price', ''),
                    tp=data.get('tp', ''),
                    sl=data.get('sl', ''),
                    date=data.get('date', ''),
                    time=data.get('time', ''),
                    win_loss=("-" if "None" in data.get('win/loss', '') else data.get('win/loss', '') + "✅" if "Win" in data.get('win/loss', '') else data.get('win/loss', '') + "❌"),
                    trader_name=data.get('trader', '')
                )
            elif data.get('position', '').upper() == 'SELL':
                message_to_send = sell_format.format(
                    header=self.extract_header(formatted_message),
                    symbol=data.get('symbol', ''),
                    entry_price=data.get('entry price', ''),
                    tp=data.get('tp', ''),
                    sl=data.get('sl', ''),
                    date=data.get('date', ''),
                    time=data.get('time', ''),
                    win_loss=("-" if "None" in data.get('win/loss', '') else data.get('win/loss', '') + "✅" if "Win" in data.get('win/loss', '') else data.get('win/loss', '') + "❌"),
                    trader_name=data.get('trader', '')
                )
            else:
                message_to_send = pending_format.format(
                    header=self.extract_header(formatted_message),
                    symbol=data.get('symbol', ''),
                    position=data.get('position', ''),
                    pending_price=data.get('pending price', ''),
                    tp=data.get('tp', ''),
                    sl=data.get('sl', ''),
                    date=data.get('date', ''),
                    time=data.get('time', ''),
                    win_loss=("-" if "None" in data.get('win/loss', '') else data.get('win/loss', '') + "✅" if "Win" in data.get('win/loss', '') else data.get('win/loss', '') + "❌"),
                    trader_name=data.get('trader', '')
                )
                # return Response({"error": "Invalid position format"}, status=status.HTTP_400_BAD_REQUEST)

                # print(request_message["message"])
                # print(request_message["package"])
            #
            customers = Customer.objects.all()
            if len(customers) >= 1:
                # customers_line_ids = [customer.line_user_id for customer in customers]
                for customer in customers:
                    if customer.expired_plan and customer.current_plan.name.lower() in request_message['package'].lower() and customer.line_user_id:
                        current_time = timezone.now()
                        three_days_later = current_time + timedelta(days=3)
                        # check not expired_plan
                        if not (current_time > customer.expired_plan):
                            mess = TextMessage(
                                text=message_to_send)
                            # line_bot_api.push_message(PushMessageRequest(
                            #     to=customer.line_user_id, messages=[mess]))
                            self.push_message(to=customer.line_user_id, message=mess)

                            # Chek 3 days later
                            if customer.expired_plan <= three_days_later:
                                mess = FlexMessage(altText="new signals", contents=FlexContainer.from_json(
                                    f'''{json.dumps(send_expired_warning(3), indent=4)}'''))
                                # line_bot_api.push_message(PushMessageRequest(
                                #     to=customer.line_user_id, messages=[mess]))
                                self.push_message(to=customer.line_user_id, message=mess)

                return Response({"success": True, "message": request_message}, status=status.HTTP_200_OK)
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def push_message(self, to, message):
        try:
            line_bot_api.push_message(PushMessageRequest(
                                    to=to, messages=[message]))
        except ApiException as e: 
            # Log error details
            logging.error(f"Status Code: {e.status}")
            logging.error(f"Request ID: {e.headers.get('x-line-request-id')}")
            logging.error(f"Error Body: {ErrorResponse.from_json(e.body)}")

    def extract_header(self, message):
        """
        Extracts the header string between '===' markers in the message.
        """
        # Regular expression to match the string between '==='
        match = re.search(r'===\s*(.*?)\s*===', message)

        # If a match is found, return the extracted string
        if match:
            return match.group(1)

        # If no match is found, return None
        return None
