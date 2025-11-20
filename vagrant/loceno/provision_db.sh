#!/bin/bash
sudo apt update
sudo apt install -y php-mysql curl mysql-server
git clone -b relative https://github.com/MatejBokal/devops-spletna

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'skrito123'; FLUSH PRIVILEGES;"

sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql -uroot -pskrito123 -e "CREATE DATABASE \`taprav-fri\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
sudo mysql -uroot -pskrito123 taprav-fri < devops-spletna/taprav-fri.sql
echo "port=3307" >> /etc/mysql/mysql.conf.d/mysqld.cnf

sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo mysql -pskrito123 -e "CREATE USER 'user'@'%' IDENTIFIED BY 'skrito123'; GRANT ALL PRIVILEGES ON \`taprav-fri\`.* TO 'user'@'%'; FLUSH PRIVILEGES;"

sudo systemctl restart mysql