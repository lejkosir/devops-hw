#!/bin/bash

# potrebne stvari
# naslednji dve vrstici odkomentiraj, ce ne uporabljas custom box
sudo apt update 
sudo apt install -y php apache2 libapache2-mod-php unzip git php-mysql curl mysql-server redis-server php-redis

# ne da dati v custom box
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# clone github repota (relative branch)
git clone -b relative https://github.com/MatejBokal/devops-spletna
# cd devops-spletna/code/taprav-fri/frontend

#baza
# rootu odstranimo geslo
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'skrito123'; FLUSH PRIVILEGES;"

sudo systemctl start mysql
sudo systemctl enable mysql
# ustvarimo bazo in uvozimo podatke
sudo mysql -uroot -pskrito123 -e "CREATE DATABASE \`taprav-fri\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
sudo mysql -uroot -pskrito123 taprav-fri < devops-spletna/taprav-fri.sql
# spremenimo port mysql na 3307, ker tam poslusa backend
echo "port=3307" >> /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql


#backend
# prekopiramo api v apache
sudo mkdir -p /var/www/html/taprav-fri/api
sudo mkdir -p /srv/frontend
sudo cp -r devops-spletna/code/taprav-fri/api /var/www/html/taprav-fri
sudo cp -r devops-spletna/code/taprav-fri/frontend /srv
# dodamo dovoljenja
sudo chown -R www-data:www-data /var/www/html/taprav-fri/api
sudo systemctl restart apache2



#backend cache
sudo systemctl enable redis-server
sudo systemctl start redis-server

# SSL - samopodpisan

sudo mkdir -p /etc/ssl/localcerts

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/localcerts/nextjs.key \
  -out /etc/ssl/localcerts/nextjs.crt \
  -subj "/CN=localhost"

sudo chown vagrant:vagrant /etc/ssl/localcerts/nextjs.key
sudo chmod 600 /etc/ssl/localcerts/nextjs.key


#frontend in zagon
cd /srv/frontend
sudo chown -R vagrant:vagrant /srv/frontend
npm install
npm run build
node server.js
# npm run dev