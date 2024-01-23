# 1-Click n8n Deployment on AWS EC2

Deploy [n8n](https://n8n.io/) with a single click on AWS EC2 using Docker Compose.

## Overview

This repository provides an easy 1-click solution to deploy n8n on an AWS EC2 instance using Docker Compose. It streamlines the process, making it accessible for both beginners and experienced users.

## Prerequisites

- [AWS Console](https://aws.amazon.com/) or [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

## Deployment Steps

1. **Launch AWS EC2 Instance:**

   Launching an AWS EC2 instance involves the following steps:

   - Log in to the [AWS Console](https://aws.amazon.com/) or use the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) on your local machine.
   - Navigate to the EC2 Dashboard.
   - Click on "Launch Instance" to choose the Amazon Machine Image (AMI)(UBUNTU), instance type, configure instance details, add storage, configure security groups, and review the instance launch.
   - Create or choose an existing key pair to secure the instance.
   - Finally, launch the EC2 instance.

   Follow the on-screen instructions to complete the deployment.


2. **1-Click Deployment Bash Script:**

   Run the following command in your terminal to deploy n8n:

   ```bash 
   curl -fsSL https://raw.githubusercontent.com/RahulRathi46/easy-n8n-aws-deploy/main/deploy_n8n.sh | bash
   ```
   
Follow any prompts to complete the deployment.

## Customization
For additional configurations or customization, refer to the official n8n documentation.
Adjust the Docker Compose file or environment variables if needed.

## Cleanup
To avoid incurring charges, make sure to terminate the EC2 instance and delete the CloudFormation stack when you are finished using n8n.

## License
This project is licensed under the MIT License.
