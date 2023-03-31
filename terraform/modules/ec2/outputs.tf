output "id" {
  value       = aws_instance.webserver_ec2.id
  description = "Instance id"
}

output "subnet_id" {
  value       = aws_subnet.pub_net.id
  description = "Subnet id"
}
