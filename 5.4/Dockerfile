FROM centos:6

MAINTAINER Alessio Cassibba (x-drum) <swapon@gmail.com>

RUN yum update -y && yum upgrade -y && yum clean all

RUN yum install -y http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum install -y centos-release-SCL
RUN yum install -y \
    nginx \
    mysql-server \
    php54-php-fpm \
    php54-mysqlnd \
    && yum clean all

EXPOSE 80 443

VOLUME ["/var/lib/mysql","/usr/share/nginx/html"]

ADD run.sh /

CMD ["/bin/bash","/run.sh"]
