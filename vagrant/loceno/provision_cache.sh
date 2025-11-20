#!/bin/bash
sudo apt update 
sudo apt install -y redis-server

sudo sed -i "s/^bind 127.0.0.1 ::1/#bind 127.0.0.1 ::1/" /etc/redis/redis.conf
sudo sed -i "s/^protected-mode yes/protected-mode no/" /etc/redis/redis.conf

sudo systemctl restart redis-server
sudo systemctl enable redis-server