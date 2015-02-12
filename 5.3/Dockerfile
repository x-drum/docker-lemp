FROM centos:6

MAINTAINER Alessio Cassibba (x-drum) <swapon@gmail.com>

RUN yum update -y && yum upgrade -y && yum clean all

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y \
    nginx \
    mysql-server \
    php-fpm \
    php-mysql \
    && yum clean all

EXPOSE 80 443

VOLUME ["/var/lib/mysql","/usr/share/nginx/html"]

ADD run.sh /

CMD ["/bin/bash","/run.sh"]
