variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "default_security_group_id" {
  description = "default security group for VPC1"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for naming resources in the EC2 module"
  type        = string
}

variable "key-pair" {
  description = "key-pair to use on this machine"
  type        = string
}
variable "public_ip" {
  description = "should public IP be associeted"
  type        = bool
  default     = false
}