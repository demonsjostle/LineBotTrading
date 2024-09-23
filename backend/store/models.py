from django.db import models
import datetime
from django.utils import timezone
from datetime import timedelta
import uuid
from django.core.exceptions import ValidationError
# https://www.geeksforgeeks.org/e-commerce-website-using-django/


class Package(models.Model):
    name = models.CharField(max_length=60)
    price = models.IntegerField(default=0)
    description = models.TextField(default='', blank=True, null=True)
    duration = models.IntegerField(default=0)

    def __str__(self):
        return self.name

    # def clean(self):
    #     if Package.objects.count() >= 3:
    #         raise ValidationError("Limit exceeded. You cannot add more items.")
    #     super(Package, self).clean()


class Customer(models.Model):
    name = models.CharField(max_length=50)
    line_user_id = models.CharField(max_length=100)
    phone = models.CharField(max_length=10, blank=True, null=True)
    email = models.EmailField(blank=True, null=True)
    current_plan = models.ForeignKey(Package,
                                     on_delete=models.CASCADE, blank=True, null=True)
    expired_plan = models.DateTimeField(default=None, blank=True, null=True)

    def __str__(self):
        return self.name


class Order(models.Model):
    order_key = models.CharField(
        max_length=250, default=None, unique=True, editable=False)
    package = models.ForeignKey(Package,
                                on_delete=models.CASCADE)
    customer = models.ForeignKey(Customer,
                                 on_delete=models.CASCADE)
    date = models.DateTimeField(default=datetime.datetime.today)
    payment_slip = models.ImageField(
        upload_to='payment_slips/', blank=True, null=True)
    is_confirmed = models.BooleanField(default=False)
    confirmed_date = models.DateTimeField(default=None, blank=True, null=True)
    expired = models.DateTimeField(default=None, blank=True, null=True)

    def save(self, *args, **kwargs):
        if not self.order_key:
            self.order_key = str(uuid.uuid4())  # Generate a unique order key

        # If the order is confirmed and the confirmed_date is not set, update it
        if self.is_confirmed and not self.confirmed_date:
            self.confirmed_date = timezone.now()

            # Also update the expired date based on the package duration
            if self.package and not self.expired:
                expired = timezone.now() + timedelta(days=self.package.duration)
                self.expired = expired
                self.customer.expired_plan = expired
            if self.customer:
                self.customer.current_plan = self.package
                self.customer.save()
        super().save(*args, **kwargs)

    def __str__(self):
        return self.order_key
