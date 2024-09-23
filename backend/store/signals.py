from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Order
from bot.models import Notification
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
    PushMessageRequest,
    MulticastRequest,

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


@receiver(post_save, sender=Order)
def order_created(sender, instance, created, **kwargs):
    if created:
        # Add your logic here, e.g., send an email, update a log, etc.
        # print(f"Order created: {instance.order_key}")
        notificaltions = Notification.objects.all()
        if (len(notificaltions) >= 1):
            notifications_user_ids = [
                notification.line_token for notification in notificaltions]

            message = TextMessage(
                text=f"New order\nname: {instance.customer.name} \norder_key: {instance.order_key}")

            line_bot_api.multicast(MulticastRequest(
                to=notifications_user_ids, messages=[message]))
