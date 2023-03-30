output "ec2_public_ipv4_address" {
  value       = aws_instance.webserver_ec2.public_ip
  description = "Public IPv4 address"
}

output "id" {
  value       = aws_instance.webserver_ec2.id
  description = "Instance id"
}
