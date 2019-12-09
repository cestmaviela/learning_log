FROM python:3.7

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY pip.conf /root/.pip/pip.conf
COPY requirements.txt /usr/src/app/
RUN pip install -r /usr/src/app/requirements.txt
RUN rm -rf /usr/src/app
COPY . /usr/src/app

#ssh
ADD ssh /root/.ssh
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/* && \
    chown -R root:root /root/.ssh && \
    echo root:qwert@12345 | chpasswd

#supervisor
RUN mkdir -p /etc/supervisor/
COPY supervisord.conf /etc/supervisor/
  
EXPOSE 22 8080
CMD supervisord -c /etc/supervisor/supervisord.conf