#!/bin/bash

# Exit on error
set -e

# Get the server's public IP
SERVER_IP=$(curl -s http://checkip.amazonaws.com)

# Install Nginx
sudo amazon-linux-extras enable nginx1 -y
sudo yum clean metadata
sudo yum install nginx -y

# Install PHP 8.1
sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo yum module reset php -y
sudo yum module enable php:remi-8.1 -y
sudo yum install -y php php-fpm php-mysqlnd
sudo dnf install -y php php-fpm php-mysqlnd
sudo yum install mariadb1011-client-utils.x86_64
sudo yum install git -y

# Create web root
sudo mkdir -p /var/www/ecommerce
sudo chown -R ec2-user:ec2-user /var/www/ecommerce

# Clone PHP app
git clone https://github.com/mani-bca/php_mysql.git /tmp/php_mysql
sudo cp -r /tmp/php_mysql/* /var/www/ecommerce/

# Set permissions
sudo chown -R nginx:nginx /var/www/ecommerce
sudo chmod -R 755 /var/www/ecommerce

# Replace default Nginx config with dynamic IP insertion
sudo tee /etc/nginx/conf.d/ecommerce.conf > /dev/null <<EOF
server {
    listen 80 default_server;
    server_name $SERVER_IP;

    root /var/www/ecommerce;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_pass unix:/run/php-fpm/www.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Start services
sudo systemctl enable nginx php-fpm
sudo systemctl start nginx php-fpm
sudo systemctl enable --now nginx php-fpm

# Test Nginx config
sudo nginx -t && sudo systemctl reload nginx
