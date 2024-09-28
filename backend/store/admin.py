from django.contrib import admin
from .models import Customer, Package, Order
from django.utils import timezone

class OrderAdmin(admin.ModelAdmin):
    search_fields = ['order_key', 'customer__name', 'package__name', 'id']
    list_display = ['order_key', 'get_customer_name', 'get_package_name', 'id', 'is_active']
    readonly_fields = ['is_active']  # Make is_active readonly
    # Custom method to display the customer name
    def get_customer_name(self, obj):
        return obj.customer.name
    get_customer_name.short_description = 'Customer Name'

    # Custom method to display the package name
    def get_package_name(self, obj):
        return obj.package.name
    get_package_name.short_description = 'Package Name'

    # Override get_queryset to update is_active for all orders
    def get_queryset(self, request):
        queryset = super().get_queryset(request)
        
        # Loop through orders and update the is_active field if expired
        for order in queryset:
            if order.expired and timezone.now() > order.expired:
                if order.is_active:  # Only update if it's currently active
                    order.is_active = False
                    order.save(update_fields=['is_active'])
        
        return queryset

admin.site.register(Customer)
admin.site.register(Package)
admin.site.register(Order, OrderAdmin)
