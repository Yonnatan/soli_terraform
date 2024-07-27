# Output the ID of the EC2 instance
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_vpc.id
}

# Output the ID of the Security Group
output "security_group_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.sg_vpc.id
}