from django.contrib import admin
from .models import Customer, Package, Order


admin.site.register(Customer)
admin.site.register(Package)
admin.site.register(Order)
