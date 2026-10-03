resource "aws_security_group" "this" {
  name        = var.name
  description = "Security group for Jenkins EC2 and ALB"
  vpc_id      = var.vpc_id

  # Jenkins UI / ALB traffic.
  # Jenkins itself is not intended to be directly exposed through the SG.
  ingress {
    description = "Jenkins HTTP from internet through ALB"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH - restrict this to your public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}
