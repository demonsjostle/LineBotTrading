from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt

from django.http import HttpResponse, HttpResponseBadRequest, HttpResponseForbidden, HttpResponseServerError, JsonResponse, HttpResponseRedirect
from decouple import config


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
    PushMessageRequest

)
from linebot.v3.webhooks import (
    MessageEvent,
    PostbackEvent,
    TextMessageContent,

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

    line_bot_api.reply_message(ReplyMessageRequest(
        replyToken=event.reply_token, messages=[response_message]))
