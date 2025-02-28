# Infra-DevOps-Stage-4

This repository contains the infrastructure automation code for the containerized Microservices TODO Application. The infrastructure is provisioned using Terraform and configured with Ansible. The deployment process provisions an EC2 instance, configures security groups, generates an Ansible inventory, and runs an Ansible playbook to deploy the application via Docker Compose.

## Overview

- **Provisioning:**  
  Terraform provisions an EC2 instance in AWS using modular components:
  - **Security Group Module:** Creates and configures security groups.
  - **EC2 Instance Module ("Ec2-server"):** Provisions the EC2 instance.
  - **Inventory Module:** Generates an inventory file for Ansible using the EC2 instance's public IP.

- **Configuration & Deployment:**  
  Ansible is used to install required host-level dependencies (Docker, Docker Compose, Git) and deploy the containerized application via Docker Compose. The playbook is automatically triggered by Terraform after provisioning.

## Prerequisites

- **Terraform** (v0.14 or later)
- **Ansible** (v2.9 or later)
- AWS credentials configured (via environment variables or AWS CLI)
- An existing AWS key pair for SSH access (the `key_name` variable must match the AWS key pair name)

## File Structure

```
Infra-DevOps-Stage-4/
├── Infrastructure/               # Terraform configuration directory
│   ├── main.tf                   # Root Terraform configuration
│   ├── variables.tf              # Root variable definitions 
│   ├── outputs.tf                # Root outputs        
│   ├── terraform.tfvars          # Variable values        
│   └── modules/                  # Terraform modules directory
│       ├── security-group/       # Security Group module    
│       │   ├── main.tf 
│       │   ├── variables.tf 
│       │   └── outputs.tf  
│       ├── Ec2-server/           # EC2 Instance module (named "Ec2-server")
│       │   ├── main.tf 
│       │   ├── variables.tf 
│       │   └── outputs.tf
│       └── inventory/            # Inventory module for Ansible
│           ├── main.tf 
│           ├── variables.tf 
│           └── outputs.tf      
├── playbook.yml                  # Ansible playbook for server configuration & deployment 
├── roles/                        # Ansible roles directory (e.g., dependencies, deployment) 
│   ├── Dependencies/ 
│   │   └── tasks/main.yml 
│   └── Deployment/ 
│       └── tasks/main.yml 
└── README.md                     # This file
```

## Deployment Process

1. **Terraform Provisioning:**
   - Change into the `Infrastructure` directory:
     ```bash
     cd Infrastructure
     ```
   - Initialize Terraform:
     ```bash
     terraform init
     ```
   - Review the plan:
     ```bash
     terraform plan
     ```
   - Apply the configuration:
     ```bash
     terraform apply -auto-approve
     ```
   This process will:
   - Provision an EC2 instance using the **Ec2-server** module.
   - Create the necessary security groups using the **security_group** module.
   - Generate an Ansible inventory file via the **inventory** module.
   - Automatically trigger the Ansible playbook using a Terraform `null_resource` (via a local-exec provisioner).

2. **Ansible Configuration & Deployment:**
   - The Ansible playbook (`playbook.yml`) is executed automatically by Terraform.
   - The playbook uses the generated inventory file (e.g., `inventory.ini`) to connect to the EC2 instance.
   - Ansible roles (located in the `roles/` directory) install Docker, Docker Compose, Git, and deploy the containerized application.

## Variables

The main variables are defined in the `terraform.tfvars` file. Example:

```hcl
aws_region    = "us-east-1"
ami           = "ami-0c94855ba95c71c99"  # Use a valid AMI for your region
instance_type = "t2.micro"
key_name      = "your-key-pair"           # The AWS key pair name (do NOT include the .pem file path)
ssh_user      = "ec2-user"
```
Additional module-specific variables (such as CIDR blocks and port settings for the security group) are defined in their respective modules and can be overridden in terraform.tfvars if needed.

## Notes

- Key Pair:
  Only the key pair's name is required. The local private key file is used separately to SSH into the instance.

- Containerized Applications:
  Since all microservices are containerized, there is no need to install language runtimes (Go, Python, etc.) on the host. The host only needs Docker and Docker Compose.

- Security Groups:
  The security group module allows configuration of ingress rules for SSH, HTTP, and HTTPS traffic through variables.

## Conclusion

This infrastructure repository provides an end-to-end solution for deploying the containerized Microservices TODO Application using Terraform and Ansible. By modularizing the configuration, you achieve a clean, maintainable, and scalable setup.
