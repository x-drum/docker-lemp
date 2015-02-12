# docker-lemp
nginx, php5-fpm, mysql (centos based)

A CentOS based image with nginx (official stable package), php5-fpm (from base or SCL), mysql (from base)

## Tags
5.3: php-5.3, nginx-1.6.x, mysql-5.1
5.4: php-5.4, nginx-1.6.x, mysql-5.1

## Notes
* If you don't specify any password using **ENV MYSQL_PASSWORD**, the default will be: **mysql** .
* By default mysql listens on localhost.

## Usage

```bash
docker run -ti --rm -p 80:80 -v /path/to/www:/usr/share/nginx/html -v /path/to/mysql:/var/lib/mysql -e MYSQL_PASSWORD=ChangeME xdrum/lemp
```
