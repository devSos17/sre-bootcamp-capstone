terraform {
  backend "s3" {
    bucket         = "sre-santiago-orozco-wize-tf-backend"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = "sre-santiago-orozco-wize-tf-backend"
}

variable "webservers" {
  type = map(any)
  default = {
    webserver1 = {
      name  = "webserver-a"
      image = "ami-02f3f602d23f1659d"
    },
    webserver2 = {
      name  = "webserver-b"
      image = "ami-02f3f602d23f1659d"
    }
  }
}
module "ec2" {
  source             = "./modules/ec2"
  security_group_ids = [aws_security_group.public_sg.id]
  for_each           = var.webservers
  instance_name      = each.value.name
  image              = each.value.image
  db_host            = var.DB_HOST
  db_user            = var.DB_USER
  db_password        = var.DB_PASSWORD
  db_database        = var.DB_DATABASE
  jwt_key            = var.JWT_KEY
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
