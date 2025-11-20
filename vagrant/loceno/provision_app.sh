#!/bin/bash
sudo apt update 
sudo apt install -y php unzip git curl

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

git clone -b relative https://github.com/MatejBokal/devops-spletna

sudo mkdir -p /srv/frontend
sudo cp -r devops-spletna/code/taprav-fri/frontend /srv
cd /srv/frontend
sudo chown -R vagrant:vagrant /srv/frontend
npm install
sed -i "s|destination: 'http://localhost:80/taprav-fri/api/:path\*'|destination: 'http://192.168.56.10:80/taprav-fri/api/:path*'|" next.config.ts

sudo mkdir -p /etc/ssl/localcerts

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/localcerts/nextjs.key \
  -out /etc/ssl/localcerts/nextjs.crt \
  -subj "/CN=localhost"

sudo chown vagrant:vagrant /etc/ssl/localcerts/nextjs.key
sudo chmod 600 /etc/ssl/localcerts/nextjs.key

npm run build
sudo chown -R vagrant:vagrant /srv/frontend
node server.js