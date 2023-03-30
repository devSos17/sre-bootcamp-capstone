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

module "ec2" {
  source             = "./modules/ec2"
  security_group_ids = [module.sg.sg_id]
  region             = var.region
  owner              = var.owner
  message            = "Workshop Demo"
}

# resource "aws_security_group" "public_sg" {
#   name = "sre-bootcamp-webserver-pub-sg"
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name        = "INSTANCE_NAME-ws6-YOUR_NAME-sg" # Update the name
#     Terraform   = "true"
#     Service     = "Security Groups"
#     Project     = "sre-bootcamp-2023"
#     Environment = "dev"
#   }
# }
