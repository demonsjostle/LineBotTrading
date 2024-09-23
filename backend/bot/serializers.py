from rest_framework import serializers
from .models import Notification


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = "__all__"


class MessageSerializer(serializers.Serializer):
    message = serializers.CharField(max_length=500)
    package = serializers.CharField(max_length=20)
