# Jenkins EC2 + ALB + VPC Terraform

This project creates only:

- VPC
- Internet Gateway
- One public subnet
- Public route table
- Security group
- Jenkins EC2 instance
- Separate Application Load Balancer
- Target group
- HTTP listener

It does NOT create EKS.

## Architecture

Internet
   |
   v
Application Load Balancer :80
   |
   v
Target Group :8080
   |
   v
Jenkins EC2 :8080

Terraform modules:

modules/
  vpc/
  security-group/
  jenkins/
  load-balancer/

## Before applying

1. Install Terraform.
2. Configure AWS CLI credentials.
3. Put the current Ubuntu 24.04 AMI ID for your AWS region in terraform.tfvars.
4. Put your existing EC2 key pair name in terraform.tfvars.

Example:

cp terraform.tfvars.example terraform.tfvars

Then edit terraform.tfvars.

## Deploy

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply

Get the Jenkins URL:

terraform output jenkins_url

Or:

terraform output -raw jenkins_url

## Jenkins initial password

SSH to the Jenkins instance:

ssh -i "your-key.pem" ubuntu@<JENKINS_PUBLIC_IP>

Then:

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Open the ALB URL from the Terraform output in your browser.

## Important security note

For learning, this example keeps the configuration simple.

Before using it beyond a temporary lab:

- Change SSH ingress from 0.0.0.0/0 to YOUR_PUBLIC_IP/32.
- Ideally use a separate security group for the ALB and EC2.
- Restrict EC2 port 8080 so only the ALB security group can reach it.
- Add HTTPS/ACM to the ALB.
- Do not store Terraform state or secrets in Git.

## Destroy

terraform destroy
