"""test_server URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url, include
from django.contrib import admin
from addressesapp.api import AddressesList
# from addressesapp import views
import addressesapp.views

urlpatterns = [
    url(r'^docs/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^$', addressesapp.views.main),
    url(r'^book/', addressesapp.views.addressesbook, name='addressesbook'),
    url(r'^delete/(?P<name>.*)/', addressesapp.views.delete_person, name='delete_person'),
    url(r'^book-search/', addressesapp.views.get_contacts, name='get_contacts'),
    url(r'^addresses-list/', AddressesList.as_view(), name='addresses-list'),
    url(r'^notfound/', addressesapp.views.notfound, name='notfound'),
    url(r'^admin/', admin.site.urls),
    # url(r'^admin/', include(admin.site.urls)),
]
