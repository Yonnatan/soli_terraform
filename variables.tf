variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable "update_kubeconfig" {
  description = "Flag to control whether to update kubeconfig"
  type        = bool
  default     = true
}