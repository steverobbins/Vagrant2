#!/usr/bin/env bash

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

apt-get -y update

apt-get -y install \
  python-software-properties

add-apt-repository ppa:ondrej/php-7.0

apt-get -y update

apt-get -y install \
  git \
  htop \
  mysql-client-core-5.6 \
  mysql-client-5.6 \
  mysql-server-5.6 \
  nginx \
  php7.0-fpm \
  php7.0-dev \
  php7.0-mysql \
  php7.0-curl \
  php7.0-gd \
  php7.0-intl \
  php7.0-sqlite3 \
  redis-server \
  redis-tools

git clone https://github.com/nikic/php-ast.git
cd php-ast
phpize
./configure
make
make install
echo '
extension=ast.so' >> /etc/php/7.0/cli/php.ini
echo '
extension=ast.so' >> /etc/php/7.0/fpm/php.ini

echo 'server {
  listen 80;
  server_name ~^(.+)\.192\.168\.50\.102\.xip\.io;
  set $project $1;
  root /var/www/html/$project;
  location / {
    index index.html index.php;
    try_files $uri $uri/ @handler;
  }
  location @handler {
    rewrite / /index.php;
  }
  location ~ .php/ {
    rewrite ^(.*.php)/ $1 last;
  }
  location ~ .php$ {
    expires        off;
    fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
  }
}
' > /etc/nginx/conf.d/vhost.conf

echo '
max_allowed_packet=1G
innodb_log_buffer_size=1G
innodb_file_per_table' >> /etc/mysql/my.cnf

sed -i "48i\\
bind-address            = 192.168.50.102" /etc/mysql/my.cnf

perl -pi -e 's/www-data/vagrant/g' /etc/nginx/nginx.conf /etc/php/7.0/fpm/pool.d/www.conf

service nginx restart
service php7.0-fpm restart
service mysql restart
redis-server /etc/redis/redis.conf 

echo 'redis-server /etc/redis/redis.conf' > /etc/rc.local

echo '[client]
user=root
password=root' > ~/.my.cnf

mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY PASSWORD 'root' WITH GRANT OPTION;
GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION;"

cd ~

curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

git clone https://github.com/netz98/n98-magerun.git
cd n98-magerun
/usr/local/bin/composer install
cd /usr/local/bin
ln -s ~/n98-magerun/bin/n98-magerun magerun

echo '
alias ls="ls -ahF --color=auto"
alias ll="ls -l"
alias grep="grep --color=auto"
alias magerun="magerun --ansi"
' >> /etc/bashrc
