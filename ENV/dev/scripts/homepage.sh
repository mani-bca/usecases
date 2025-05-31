#!/bin/bash
yum update -y
yum install -y nginx
echo "<html><body><h1>Welcome to the Homepage (Target Group A)</h1></body></html>" > /usr/share/nginx/html/index.html
systemctl enable nginx
systemctl start nginx