#!/bin/bash

# Interactive script to deploy n8n with Docker Compose

echo "Welcome to the n8n deployment script"

# Step 1: Install Docker
echo "Step 1: Install Docker"
# Add instructions for Docker installation based on the user's Linux distribution
# For now, assuming Ubuntu as in the provided documentation
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Step 2: Optional - Non-root user access
echo "Step 2: Optional - Allowing non-root user access to Docker"
# Add instructions for allowing non-root user access to Docker
# This step can be skipped if not needed
# ...

# Step 3: Install Docker-Compose
echo "Step 3: Install Docker-Compose"
# Add instructions for Docker-Compose installation based on the user's Linux distribution
# For now, assuming Ubuntu as in the provided documentation
sudo apt-get install docker-compose-plugin

# Step 4: DNS Setup
echo "Step 4: DNS Setup"
# Add instructions for DNS setup
# Prompt user for subdomain and IP address
read -p "Enter the subdomain for n8n: " SUBDOMAIN
read -p "Enter the IP address of your server: " SERVER_IP

# Prompt the user to add A record to their domain
echo "To complete the DNS setup, add the following A record to your domain settings:"
echo "Type: A"
echo "Name: ${SUBDOMAIN}"
echo "IP address: ${SERVER_IP}"

# Step 5: Create Docker Compose file
echo "Step 5: Create Docker Compose file"
# Generate the Docker Compose file using the provided example with additional environment variables
cat <<EOF > docker-compose.yml
version: "3.7"

services:
  traefik:
    image: "traefik"
    restart: always
    command:
      - "--api=true"
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entryPoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.mytlschallenge.acme.tlschallenge=true"
      - "--certificatesresolvers.mytlschallenge.acme.email=${SSL_EMAIL}"
      - "--certificatesresolvers.mytlschallenge.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - traefik_data:/letsencrypt
      - /var/run/docker.sock:/var/run/docker.sock:ro

  n8n:
    image: docker.n8n.io/n8nio/n8n
    restart: always
    ports:
      - "127.0.0.1:5678:5678"
    labels:
      - traefik.enable=true
      - traefik.http.routers.n8n.rule=Host(\`${SUBDOMAIN}.${DOMAIN_NAME}\`)
      - traefik.http.routers.n8n.tls=true
      - traefik.http.routers.n8n.entrypoints=web,websecure
      - traefik.http.routers.n8n.tls.certresolver=mytlschallenge
      - traefik.http.middlewares.n8n.headers.SSLRedirect=true
      - traefik.http.middlewares.n8n.headers.STSSeconds=315360000
      - traefik.http.middlewares.n8n.headers.browserXSSFilter=true
      - traefik.http.middlewares.n8n.headers.contentTypeNosniff=true
      - traefik.http.middlewares.n8n.headers.forceSTSHeader=true
      - traefik.http.middlewares.n8n.headers.SSLHost=${DOMAIN_NAME}
      - traefik.http.middlewares.n8n.headers.STSIncludeSubdomains=true
      - traefik.http.middlewares.n8n.headers.STSPreload=true
      - traefik.http.routers.n8n.middlewares=n8n@docker
    environment:
      - N8N_HOST=${SUBDOMAIN}.${DOMAIN_NAME}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://${SUBDOMAIN}.${DOMAIN_NAME}/
      - GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
      - EXECUTIONS_DATA_PRUNE=true
      - EXECUTIONS_DATA_PRUNE_TIMEOUT=604800
      - DB_SQLITE_VACUUM_ON_STARTUP=true
      - EXECUTIONS_DATA_MAX_AGE=7
    volumes:
      - n8n_data:/home/node/.n8n

volumes:
  traefik_data:
    external: true
  n8n_data:
    external: true
EOF

# Step 6: Create .env file
echo "Step 6: Create .env file"
# Prompt user for the required environment variables
read -p "Enter the top-level domain (e.g., example.com): " DOMAIN_NAME
read -p "Enter the email address for SSL certificate creation: " SSL_EMAIL
read -p "Enter the optional timezone (e.g., Europe/Berlin): " GENERIC_TIMEZONE

# Generate the .env file with user input
cat <<EOF > .env
# The top level domain to serve from
DOMAIN_NAME=${DOMAIN_NAME}

# The subdomain to serve from
SUBDOMAIN=${SUBDOMAIN}

# DOMAIN_NAME and SUBDOMAIN combined decide where n8n will be reachable from
# above example would result in: https://n8n.example.com

# Optional timezone to set which gets used by Cron-Node by default
# If not set, New York time will be used
GENERIC_TIMEZONE=${GENERIC_TIMEZONE}

# The email address to use for the SSL certificate creation
SSL_EMAIL=${SSL_EMAIL}
EOF

# Step 7: Create data folder
echo "Step 7: Create data folder"
# Add instructions to create Docker volumes
sudo docker volume create n8n_data
sudo docker volume create traefik_data

# Step 8: Start Docker Compose
echo "Step 8: Start Docker Compose"
sudo docker-compose up -d

echo "Deployment completed successfully!"
