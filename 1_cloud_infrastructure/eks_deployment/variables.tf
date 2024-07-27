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

variable "cluster_name" {
  description = "kubernetes cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "kubernetes cluster_endpoint"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "kubernetes cluscluster_ca_certificatete"
  type        = string
}

variable "cluster_namespace" {
  description = "The namespace where we wish to deploy everything"
  type        = string
}

variable "alb_arn" {
  description = "The LB name that the ingress resource needs to connect to"
  type        = string
}
