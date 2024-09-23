from django.urls import path
from .views import (CustomerListCreateView, CustomerDetailView, OrderListCreateView,
                    OrderDetailView, PackageListCreateView, PackageDetailView)


urlpatterns = [
    path('api/store/customer/', CustomerListCreateView.as_view(),
         name='customer-list-create'),
    path('api/store/notification/<int:pk>/',
         CustomerDetailView.as_view(), name='customer-detail'),
    path('api/store/package/', PackageListCreateView.as_view(),
         name='package-list-create'),
    path('api/store/package/<int:pk>/',
         PackageDetailView.as_view(), name='package-detail'),
    path('api/store/order/', OrderListCreateView.as_view(),
         name='order-list-create'),
    path('api/store/order/<int:pk>/',
         OrderDetailView.as_view(), name='order-detail'),

]
