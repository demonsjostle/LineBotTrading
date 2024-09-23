from django.urls import path

from .views import index, NotificationDetailView, NotificationListCreateView, SendMessageAPIView

urlpatterns = [
    path('', index, name='index'),
    path('api/bot/notification/', NotificationListCreateView.as_view(),
         name='notification-list-create'),
    path('api/bot/notification/<int:pk>/',
         NotificationDetailView.as_view(), name='notification-detail'),
    path('api/send-message/', SendMessageAPIView.as_view(), name='send_message'),

]
