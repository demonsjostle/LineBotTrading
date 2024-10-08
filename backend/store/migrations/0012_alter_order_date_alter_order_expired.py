# Generated by Django 5.1 on 2024-09-22 14:47

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('store', '0011_package_duration'),
    ]

    operations = [
        migrations.AlterField(
            model_name='order',
            name='date',
            field=models.DateTimeField(default=datetime.datetime.today),
        ),
        migrations.AlterField(
            model_name='order',
            name='expired',
            field=models.DateTimeField(blank=True, default=None, null=True),
        ),
    ]
