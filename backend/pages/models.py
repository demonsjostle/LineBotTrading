from django.db import models


class PageContent(models.Model):
    about = models.TextField(blank=True, null=True)
