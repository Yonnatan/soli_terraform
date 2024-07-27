variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "cluster_namespace" {
  description = "The namespace where we wish to deploy everything"
  type        = string
  default     = "default"
}

variable "update_kubeconfig" {
  description = "Flag to control whether to update kubeconfig"
  type        = bool
}