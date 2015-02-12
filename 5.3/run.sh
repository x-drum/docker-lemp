#!/bin/bash
set -e

: ${MYSQL_PASSWORD:="mysql"}

if [ ! -d /var/lib/mysql/mysql ]; then
  sed -i -e "/mysqld]/a bind-address=127.0.0.1" /etc/my.cnf
  /etc/init.d/mysqld start

  mysql -u root -e "DELETE FROM mysql.user WHERE User=''"
  mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
  mysql -u root -e "DROP DATABASE test;"
  mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
  mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('${MYSQL_PASSWORD}') WHERE User='root'"
  mysql -u root -e "FLUSH PRIVILEGES"
fi

if [ ! -f /etc/nginx/conf.d/php-fpm.conf ]; then
  rm -f /etc/nginx/conf.d/*

  sed -i -e s:=\ apache:=\ nginx:g /etc/php-fpm.d/www.conf
  sed -i -e "s:php_value\[session.save_path].*:php_value\[session.save_path] = /tmp:g" /etc/php-fpm.d/www.conf
  sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php.ini

  sed -i -e "s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
  sed -i -e "s/gzip\s\son;*/\tgzip on;\n\tgzip on;\n\tgzip_min_length 1100;\n\tgzip_buffers 4 8k;\n\tgzip_types text\/plain;\n\tserver_tokens off;/" /etc/nginx/nginx.conf

cat <<'EOF' > /etc/nginx/conf.d/php-fpm.conf
server {
    listen 80 default_server;
    server_name  _;
    root /usr/share/nginx/html;

    location / {
        index index.php index.html index.htm;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF
fi

/etc/init.d/mysqld start
/etc/init.d/php-fpm start
/usr/sbin/nginx -g "daemon off;"

exec "$@"
