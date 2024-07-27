output "vpc_endpoint_dns_name" {
  description = "The DNS name of the VPC Endpoint"
  value       = aws_vpc_endpoint.endpoint.dns_entry[0].dns_name
}