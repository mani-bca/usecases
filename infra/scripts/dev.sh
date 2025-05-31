#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
git clone https://github.com/mani-bca/usecase-3.git
cd usecase-3/infra/docker
curl -SL https://github.com/docker/compose/releases/download/v2.33.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose up -d
#eod