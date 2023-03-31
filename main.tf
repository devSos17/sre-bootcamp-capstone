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

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name      = "main_vpc"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name      = "main_gw"
    Terraform = "true"
  }
}

resource "aws_route_table" "rtb_pub" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "main_rtb"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "public_rtba" {
  for_each       = module.ec2
  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.rtb_pub.id
}

variable "webservers" {
  type = map(any)
  default = {
    webserver1 = {
      name = "webserver-a"
      zone = "us-east-1a"
      cidr = "10.0.1.0/24"
    },
    webserver2 = {
      name = "webserver-b"
      zone = "us-east-1b"
      cidr = "10.0.2.0/24"
    }
  }
}
module "ec2" {
  source             = "./modules/ec2"
  security_group_ids = [aws_security_group.webserver_sg.id]
  for_each           = var.webservers
  instance_name      = each.value.name
  zone               = each.value.zone
  cidr               = each.value.cidr
  db_host            = var.DB_HOST
  db_user            = var.DB_USER
  db_password        = var.DB_PASSWORD
  db_database        = var.DB_DATABASE
  jwt_key            = var.JWT_KEY
  ghcr_user          = var.GHCR_USERNAME
  ghcr_token         = var.GHCR_PASSWORD
  vpc_id             = aws_vpc.main_vpc.id
}

# Securtiy groups

resource "aws_security_group" "public_sg" {
  name   = "sre-bootcamp-pub-sg"
  vpc_id = aws_vpc.main_vpc.id

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
  name   = "sre-bootcamp-webserver-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }
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
    Name        = "webserver-sg"
    Terraform   = "true"
    Environment = terraform.workspace
    Service     = "Security Groups"
    Project     = "sre-bootcamp"
  }
}

# Load balancer
resource "aws_lb" "loadbalancer" {
  name               = "loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = values(module.ec2)[*].subnet_id

  tags = {
    Name        = "loadbalancer"
    Terraform   = "true"
    Environment = terraform.workspace
    Project     = "sre-bootcamp"
  }
}

resource "aws_lb_target_group" "api_tg" {
  vpc_id   = aws_vpc.main_vpc.id
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
}
resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "webservers_tg" {
  target_group_arn = aws_lb_target_group.api_tg.arn
  for_each         = module.ec2
  target_id        = each.value.id
  port             = 80
}

# CLoudflare for dns
provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}

# Create a record
resource "cloudflare_record" "sre-bootcamp" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "sre-bootcamp"
  value   = aws_lb.loadbalancer.dns_name
  type    = "CNAME"
  proxied = true
}

