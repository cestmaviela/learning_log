'''为应用程序users定义URL模式'''

from django.conf.urls import url
from django.contrib.auth.views import login
from . import views

urlpatterns = [
    #登陆页面
    url(r'^login/$',login,{'template_name':"users/login.html"}, name='login'),
    #退出页面
    url(r'^logout/$', views.logout_view, name='logout'),
    #注册页面
    url(r'^register/$', views.register, name="register"),
]