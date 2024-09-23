from django.urls import path
from .views import (CustomerCreateView, CustomerDetailByLineIDView, OrderListCreateView,
                    OrderDetailView, PackageListCreateView, PackageDetailView)


urlpatterns = [
    path('api/store/customer/create/', CustomerCreateView.as_view(),
         name='customer-list-create'),
    path('api/store/customer/<str:line_user_id>/',
         CustomerDetailByLineIDView.as_view(), name='customer-detail'),
    path('api/store/package/', PackageListCreateView.as_view(),
         name='package-list-create'),
    path('api/store/package/<int:pk>/',
         PackageDetailView.as_view(), name='package-detail'),
    path('api/store/order/', OrderListCreateView.as_view(),
         name='order-list-create'),
    path('api/store/order/<int:pk>/',
         OrderDetailView.as_view(), name='order-detail'),

]
