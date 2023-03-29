terraform {
  backend "s3" {}
}

provider "aws" {
  version = "~> 3.0,!= 3.14.0"
  region  = "us-east-2" # Update with your preferred region
}

resource "aws_instance" "state_ws6_daniela_ec2" {
  ami           = "ami-074cce78125f09d61" # For us-east-2
  instance_type = "t2.micro"
  user_data     = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              EOF
  tags = {
    Name        = "state-ws6-daniela-ec2" # Update the name
    Terraform   = "true"
    Service     = "EC2"
    Project     = "sre-bootcamp-2023-ws6"
    Environment = terraform.workspace
    Count       = "${terraform.workspace == "default" ? 5 : 1}"
  }
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
