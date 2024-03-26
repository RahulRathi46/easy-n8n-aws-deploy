# N8N Deployment

Deploy [n8n](https://n8n.io/) using Docker Compose.

## Overview

This repository provides an easy solution to deploy n8n on an cloud instance using Docker Compose. It streamlines the process, making it accessible for both beginners and experienced users.

## Deployment Steps

1. **Launch Instance:**

   - Launching an instance.

2. **Setting up Docker & Docker Compose**

   Run the following command in your terminal to deploy n8n:

   # Step 2.1: Install Docker

   ```bash 
   sudo apt-get remove docker docker-engine docker.io containerd runc
   sudo apt-get update
   sudo apt-get install ca-certificates curl gnupg lsb-release
   sudo mkdir -p /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io
   ```

   # Step 2.2: Optional: Non-root user access

   ```bash 
   sudo usermod -aG docker ${USER}
   ```

   # Step 2.3: Install Docker-Compose

   ```bash 
   sudo apt-get install docker-compose-plugin
   ```

2. **Deploying N8N**


## Customization
For additional configurations or customization, refer to the official n8n documentation.
Adjust the Docker Compose file or environment variables if needed.

## License
This project is licensed under the MIT License.
