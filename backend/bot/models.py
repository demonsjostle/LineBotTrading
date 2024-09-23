from django.db import models


class Notification(models.Model):
    token_name = models.CharField(max_length=50)
    line_token = models.CharField(max_length=100)

    def __str__(self):
        return self.token_name
