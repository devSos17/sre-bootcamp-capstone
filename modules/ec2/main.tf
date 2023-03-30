resource "aws_instance" "webserver_ec2" {
  key_name                    = "sre-devsos"
  ami                         = var.image
  instance_type               = "t2.micro"
  availability_zone           = var.zone
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = aws_subnet.pub_net.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
													#!/bin/bash
													yum update -y
													yum install -y docker
													systemctl enable docker
													systemctl start docker
													docker login --user ${var.ghcr_user} --password ${var.ghcr_token}
													docker run \
														--restart always \
														-e DB_HOST=${var.db_host} \
														-e DB_USER=${var.db_user} \
														-e DB_PASSWORD=${var.db_password} \
														-e DB_DATABASE=${var.db_database} \
														-e JWT_KEY=${var.jwt_key} \
														-p 80:8000 -d \
														${var.container}
													EOF
  tags = {
    Name        = "${var.instance_name}"
    Terraform   = "true"
    Service     = "EC2"
    Project     = "sre-bootcamp"
    Environment = terraform.workspace
    Count       = "${terraform.workspace == "default" ? 5 : 1}"
  }
}

resource "aws_subnet" "pub_net" {
  vpc_id            = var.vpc_id
  availability_zone = var.zone
  cidr_block        = var.cidr
}
