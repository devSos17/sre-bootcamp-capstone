terraform {
  backend "s3" {}
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = us-east-1
}

variable "webservers" {
  type = map(any)
  default = {
    webserver1 = {
      name  = "webserver-a"
      image = "us-east-1"
    },
    webserver2 = {
      name  = "webserver-b"
      image = "us-east-2"
    }
  }

}

module "ec2" {
  source             = "./modules/ec2"
  security_group_ids = [aws_security_group.public_sg.sg_id]
  for_each           = var.webservers
  instance_name      = each.value.name
  images             = each.value.image
}

resource "aws_security_group" "public_sg" {
  name = "sre-bootcamp-webserver-pub-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "public-webserver-sg" # Update the name
    Terraform   = "true"
    Environment = terraform.workspace
    Service     = "Security Groups"
    Project     = "sre-bootcamp"
  }
}
