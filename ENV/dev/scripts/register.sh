#!/bin/bash
yum update -y
yum install -y nginx
mkdir -p /usr/share/nginx/html/register
echo "<html><body><h1>This is the Registration Page (Target Group C)</h1></body></html>" > /usr/share/nginx/html/register/index.html
systemctl enable nginx
systemctl start nginx