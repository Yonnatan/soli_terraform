output "jump_server_public_ip" {
  value       = module.jump_server.public_ip
  description = "The public IP of the jump server"
}

output "ec2_1_private_ip" {
  value       = module.ec2_1.private_ip
  description = "The private IP of EC2 instance 1"
}

output "ec2_2_private_ip" {
  value       = module.ec2_2.private_ip
  description = "The private IP of EC2 instance 2"
}
/*
output "cloudfront_domain_name" {
  value       = module.cloud_infrastructure.cloudfront_domain_name
  description = "The domain name of the CloudFront distribution"
}
*/
output "vpc1_to_vpc2_endpoint" {
  value       = module.private_link_vpc1_to_vpc2.vpc_endpoint_dns_name
  description = "The DNS names of the VPC Endpoint from VPC1 to VPC2"
}

output "vpc2_to_vpc1_endpoint" {
  value       = module.private_link_vpc2_to_vpc1.vpc_endpoint_dns_name
  description = "The DNS names of the VPC Endpoint from VPC2 to VPC1"
}