#!/bin/bash
sudo apt update
sudo apt install -y php apache2 libapache2-mod-php unzip git curl php-mysql php-redis
git clone -b relative https://github.com/MatejBokal/devops-spletna

sudo mkdir -p /var/www/html/taprav-fri/api
sudo cp -r devops-spletna/code/taprav-fri/api /var/www/html/taprav-fri
sudo chown -R www-data:www-data /var/www/html/taprav-fri/api

sudo sed -i "s/define('DB_USER', 'root');/define('DB_USER', 'user');/" /var/www/html/taprav-fri/api/includes/config.php
sudo sed -i "s/define('DB_HOST', '127.0.0.1');/define('DB_HOST', '192.168.56.11');/" /var/www/html/taprav-fri/api/includes/config.php
sed -i "s/\$redis->connect('127\.0\.0\.1', 6379)/\$redis->connect('192.168.56.12', 6379)/" /var/www/html/taprav-fri/api/includes/config.php

sudo systemctl restart apache2