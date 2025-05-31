#!/bin/bash
yum update -y
yum install -y nginx
mkdir -p /usr/share/nginx/html/image
echo "<html><body><h1>This is the Image Page (Target Group B)</h1></body></html>" > /usr/share/nginx/html/image/index.html
systemctl enable nginx
systemctl start nginx