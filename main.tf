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
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# module "tf-state" {
#   source      = "./modules/tf-state"
#   bucket_name = "sre-santiago-orozco-wize-tf-backend"
# }

variable "webservers" {
  type = map(any)
  default = {
    webserver1 = {
      name = "webserver-a"
      zone = "us-east-1a"
    },
    webserver2 = {
      name = "webserver-b"
      zone = "us-east-1b"
    }
  }
}
module "ec2" {
  source             = "./modules/ec2"
  security_group_ids = [aws_security_group.webserver_sg.id]
  for_each           = var.webservers
  instance_name      = each.value.name
  zone               = each.value.zone
  db_host            = var.DB_HOST
  db_user            = var.DB_USER
  db_password        = var.DB_PASSWORD
  db_database        = var.DB_DATABASE
  jwt_key            = var.JWT_KEY
  ghcr_user          = var.GHCR_USERNAME
  ghcr_token         = var.GHCR_PASSWORD
}

# Securtiy groups

resource "aws_security_group" "public_sg" {
  name = "sre-bootcamp-pub-sg"
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name        = "public-loadbalancer-sg"
    Terraform   = "true"
    Environment = terraform.workspace
    Service     = "Security Groups"
    Project     = "sre-bootcamp"
  }
}

resource "aws_security_group" "webserver_sg" {
  name = "sre-bootcamp-webserver-sg"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
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
    Name        = "webserver-sg"
    Terraform   = "true"
    Environment = terraform.workspace
    Service     = "Security Groups"
    Project     = "sre-bootcamp"
  }
}

# Load balancer
resource "aws_elb" "loadbalancer" {
  name               = "loadbalancer"
  availability_zones = ["us-east-1a", "us-east-1b"]
  security_groups    = [aws_security_group.public_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/_health"
    interval            = 30
  }

  instances                 = values(module.ec2)[*].id
  cross_zone_load_balancing = true
  tags = {
    Name        = "loadbalancer"
    Terraform   = "true"
    Environment = terraform.workspace
    Project     = "sre-bootcamp"
  }
}

# CLoudflare for dns
provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}

# Create a record
resource "cloudflare_record" "sre-bootcamp" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "sre-bootcamp"
  value   = aws_elb.loadbalancer.dns_name
  type    = "CNAME"
  proxied = true
}

