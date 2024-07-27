variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "The Subnet IDs"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "Name for the EKS Cluster"
  type        = string
}

variable "update_kubeconfig" {
  description = "Flag to control whether to update kubeconfig"
  type        = bool
}