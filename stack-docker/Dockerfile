FROM centos:7

WORKDIR /var/www/html

RUN yum update -y && \
    yum install -y epel-release yum-utils http://rpms.remirepo.net/enterprise/remi-release-$(rpm -E '%{rhel}').rpm && \
    yum-config-manager --enable remi-php81 && \
    yum update -y && \
    yum install -y git wget unzip httpd php php-cli php-mysqli php-mysql php-gd php-bcmath php-pdo php-mbstring php-xml

COPY ./configs/livehelperchat.conf /etc/httpd/conf.d/livehelperchat.conf
COPY ./configs/httpd.conf  /etc/httpd/conf/httpd.conf 

RUN wget https://github.com/LiveHelperChat/livehelperchat/releases/download/4.34v/4.34v-with-dependencies.zip
RUN unzip 4.34v-with-dependencies.zip

RUN cp -r livehelperchat-master /var/www/html/livehelperchat 
RUN chown -R apache: /var/www/html/livehelperchat
RUN chmod -R 755 /var/www/html/livehelperchat

RUN rm -rf livehelperchat-master
RUN rm -rf 4.34v-with-dependencies.zip

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]