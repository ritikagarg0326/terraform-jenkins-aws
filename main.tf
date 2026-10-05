terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

module "security_group" {
  source = "./modules/security-group"

  name   = "${var.project_name}-sg"
  vpc_id = module.vpc.vpc_id
}

module "jenkins" {
  source = "./modules/jenkins"

  name              = "${var.project_name}-jenkins"
  ami_id            = var.ami_id
  instance_type     = var.jenkins_instance_type

  # Jenkins runs in the first public subnet
  subnet_id         = module.vpc.public_subnet_ids[0]

  key_name          = var.key_name
  security_group_id = module.security_group.security_group_id
}

module "load_balancer" {
  source = "./modules/load-balancer"

  name = "${var.project_name}-alb"

  vpc_id = module.vpc.vpc_id

  # ALB needs both subnets in different AZs
  public_subnet_ids = module.vpc.public_subnet_ids

  security_group_id = module.security_group.security_group_id

  target_instance_id = module.jenkins.instance_id
  target_port        = 8080
}