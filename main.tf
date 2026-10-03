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

  name               = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "security_group" {
  source = "./modules/security-group"

  name   = "${var.project_name}-sg"
  vpc_id = module.vpc.vpc_id
}

module "jenkins" {
  source = "./modules/jenkins"

  name                = "${var.project_name}-jenkins"
  ami_id              = var.ami_id
  instance_type       = var.jenkins_instance_type
  subnet_id           = module.vpc.public_subnet_id
  key_name            = var.key_name
  security_group_id   = module.security_group.security_group_id
}

module "load_balancer" {
  source = "./modules/load-balancer"

  name             = "${var.project_name}-alb"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id

  target_instance_id = module.jenkins.instance_id
  target_port        = 8080
}
