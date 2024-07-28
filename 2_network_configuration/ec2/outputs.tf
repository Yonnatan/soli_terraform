output "public_ip" {
  value       = try(aws_instance.ec2_vpc.public_ip, null)
  description = "The public IP of the EC2 instance (if assigned)"
}

output "private_ip" {
  value       = aws_instance.ec2_vpc.private_ip
  description = "The private IP of the EC2 instance"
}

output "ec2_instance_id" {
  value       = aws_instance.ec2_vpc.id
  description = "The ID of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.sg_vpc.id
  description = "The ID of the security group associated with the EC2 instance"
}