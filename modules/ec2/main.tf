resource "aws_instance" "webserver_ec2" {
  ami                    = var.images
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.security_group_ids
  user_data              = <<-EOF
													#!/bin/bash
													yum update -y
													yum install -y docker
													docker run \
														-e DB_HOST=${var.db_host} \
														-e DB_USER=${var.db_user} \
														-e DB_PASSWORD=${var.db_password} \
														-e DB_DATABASE=${var.db_database} \
														-e JWT_KEY=${var.JWT_KEY} \
														-p 8000:80 \
														${var.container}
													EOF
  tags = {
    Name        = "web-server-${var.instance_name}" # Update the name
    Terraform   = "true"
    Service     = "EC2"
    Project     = "sre-bootcamp"
    Environment = terraform.workspace
    Count       = "${terraform.workspace == "default" ? 5 : 1}"
  }
}
