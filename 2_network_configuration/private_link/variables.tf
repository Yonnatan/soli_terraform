variable "vpc_id" {
  description = "VPC ID where the Network Load Balancer is deployed"
  type        = string
}

variable "peer_vpc_id" {
  description = "VPC ID of the peer VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets in the VPC where the NLB and VPC endpoint will be deployed"
  type        = list(string)
}

variable "peer_subnet_ids" {
  description = "Subnets in the VPC where the NLB and VPC endpoint will be deployed"
  type        = list(string)
}


variable "security_group_ids" {
  description = "Security group IDs to associate with the VPC endpoint"
  type        = list(string)
}

variable "instance_id" {
  description = "EC2 instance ID to attach to the NLB Target Group"
  type        = string
}

variable "name_suffix" {
  description = "Suffix to differentiate the NLB and Target Group names"
  type        = string
}