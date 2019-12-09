**构建一个学习笔记app，是参考python 从入门到实践的实践案例整理，这里记录下整个过程的关键。而且可以直接使用

# 1.创建项目
## 1.1创建一个目录:./learning_log/

## 1.2建立一个独立的ll_env的编译虚拟环境；
	learning_log$ python -m venv ll_env
	learning_log$
	这里运行了模块 venv ，并使用它来创建一个名为ll_env的虚拟环境
	
## 1.3激活运行环境，
learning_log$ source ll_env/bin/activate
(ll_env)learning_log$
	---因为我用的是windows的环境，所以方法是：
C:\Users\cestm>C:\Users\cestm\python\learning_log\ll_env\Scripts\activate
(ll_env) C:\Users\cestm>       
	如果你使用的是Windows系统，请使用命令 ll_env\Scripts\activate （不包含 source ）来
	激活这个虚拟环境

## 1.4.在虚拟环境安装Djianggo等；
(ll_env)learning_log$ pip install Django
Installing collected packages: Django
Successfully installed Django
Cleaning up...
(ll_env)learning_log$

	注意：查询django版本：python -m django --version
	
## 1.5 再Djiango中创建项目
(ll_env)learning_log$ django-admin.py startproject learning_log .
 (ll_env)learning_log$ ls
learning_log ll_env manage.py
(ll_env)learning_log$ ls learning_log
__init__.py settings.py urls.py wsgi.py

## 1.6 创建数据库
 默认使用的是SQLite数据库。
(ll_env)learning_log$ python manage.py migrate
 Operations to perform:
Synchronize unmigrated apps: messages, staticfiles
Apply all migrations: contenttypes, sessions, auth, admin
-- snip --
Applying sessions.0001_initial... OK
(ll_env)learning_log$ ls
db.sqlite3 learning_log ll_env manage.py

## 1.7查看项目
(ll_env)learning_log$ python manage.py runserver
Performing system checks...
 System check identified no issues (0 silenced).
July 15, 2015 - 06:23:51
 Django version 1.8.4, using settings 'learning_log.settings'
 Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.

如果出现错误消息“That port is already in use”（指定端口已被占用），请执行命令 python
manage.py runserver 8001

# 2.创建应用程序
## 2.1 Django项目由一系列应用程序组成，切换到manage.py所在的目录。激活该虚拟环境，再执行命令 startapp ：
learning_log$ source ll_env/bin/activate
(ll_env)learning_log$ python manage.py startapp learning_logs
(ll_env)learning_log$ ls
db.sqlite3 learning_log learning_logs ll_env manage.py
(ll_env)learning_log$ ls learning_logs/
admin.py __init__.py migrations models.py tests.py views.py

最重要的文件是models.py、admin.py和views.py。

## 2.2 我们将使用models.py来定义我们要在应用程序中管理的数据。
构造topic的数据库中的数据结构--定义模型/激活模型
创建管理网站的超级用户，然后再向管理网站注册模型。admin.py 操作
然后再创建entry模型，先修改model.py定义模型，再迁移模型，在通过修改adnin.py对网站注册entry。

## 2.3 django shell 进行调试
ll_env)learning_log$ python manage.py shell
>>> from learning_logs.models import Topic
>>> Topic.objects.all()
[<Topic: Chess>, <Topic: Rock Climbing>]


然后接下来就是，映射URL/编写视图/编写模板的过程
其中将公用的模板抽象出单独文件，并被其他的页面继承（父子模板）
其中自动创建主题/entry，需要增加一个创建表单。在Django中，创建表单的最简单方式是使用ModelForm，

# 3.基础的WEBapp运行后，再用bootstrap3进行前端优化；

# 4.这些过程再通过github进行代码管理。




**创建docker发布这个webapp**


# 1.首先就是centos上要开启了docker功能；
>systemctl daemon-reload
>systemctl restart docker.service

# 2.然后再是将webapp以及必要的Dockerfile/requirement.txt/pip.conf/supervisord.conf放入相同的目录中。
因为要开启多个进程：即Django以及sshd，所以还要用到supervisord，即：supervisord.conf文件。

*其中关键是理解
>Dockerfile 主要描述对于容器的操作,本例是创建ssh以及supervisor进程，还有就是创建webapp的环境；
>pip.conf 主要是安装国内源
>requirement.txt  主要是描述容器的环境
>supervisord.conf 主要是描述supervisord的配置，可以启动 django，sshd两个进程。
*详细可以参考附件案例。

# 3.构建镜像：
>docker build -t learning_log_django:1.0 .

# 4.然后开启容器,后台运行：
>docker run -d --name learning_log_django -p 2022:22 -p 8080:8091  learning_log_django:1.0
*2022:22 --也就是将docker的22端口映射到宿主机的端口2022，对外ssh采用 ip:2022访问
*8080:8091  --对外web访问用ip：8080访问
*前台运行：
>docker run -it --rm -p 8080:8091 -p 2022:22 --name learning learning_log_django:1.0

# 5.最后访问
接下来可以通过ssh IP：2022 以及http://ip:8080进行设备操作。
