from django.shortcuts import render
from rest_framework import generics
from .models import Package, Order, Customer
from .serializers import OrderSerializer, PackageSerializer, CustomerSerializer
from rest_framework.exceptions import NotFound

from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator


class OrderListCreateView(generics.ListCreateAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer


class OrderDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer


class PackageListCreateView(generics.ListCreateAPIView):
    queryset = Package.objects.all()
    serializer_class = PackageSerializer


class PackageDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Package.objects.all()
    serializer_class = PackageSerializer


class CustomerCreateView(generics.CreateAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer


class CustomerDetailByLineIDView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = CustomerSerializer

    # Override get_object to filter by line_user_id
    def get_object(self):
        line_user_id = self.kwargs.get('line_user_id')
        try:
            return Customer.objects.get(line_user_id=line_user_id)
        except Customer.DoesNotExist:
            raise NotFound('Customer not found with this LINE user ID')

    # Enable partial updates
    def update(self, request, *args, **kwargs):
        kwargs['partial'] = True
        return super().update(request, *args, **kwargs)
