#!/bin/bash

# --- Prerequisites ---
echo "Updating package lists..."
sudo apt update

echo "Installing Docker..."
sudo apt install -y docker.io

echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Installing Docker Compose..."
sudo apt install -y docker-compose

# --- Focalboard Setup ---
echo "Creating a directory for Focalboard..."
mkdir -p ~/focalboard
cd ~/focalboard

echo "Creating docker-compose.yml file..."
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  focalboard:
    image: mattermost/focalboard:stable
    ports:
      - "80:80" # Adjust the host port if needed
    volumes:
      - focalboard_data:/var/lib/focalboard
    restart: unless-stopped

volumes:
  focalboard_data:
EOF

echo "Starting Focalboard using Docker Compose..."
docker-compose up -d

echo "Focalboard should now be running."
echo "You can access it in your web browser using the public IP address of your EC2 instance on port 80."
echo "For example: http://YOUR_EC2_PUBLIC_IP"

echo "Please note:"
echo "- If you are using a security group on your EC2 instance, make sure to allow inbound traffic on port 80 (or the port you mapped in docker-compose.yml)."
echo "- The data for Focalboard will be stored in the 'focalboard_data' Docker volume."
echo "- You can stop and start Focalboard using 'docker-compose stop' and 'docker-compose start' respectively from the ~/focalboard directory."
echo "- To see the logs, use 'docker-compose logs -f focalboard'."