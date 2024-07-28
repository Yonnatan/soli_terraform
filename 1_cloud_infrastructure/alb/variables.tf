variable "alb_name" {
  description = "Name of the ALB"
  type        = string
  default     = "tester"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "cluster_name" {
  description = "kubernetes cluster"
  type        = string
}