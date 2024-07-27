variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_origin_id" {
  description = "Unique identifier for the ALB origin"
  type        = string
  default     = "ALB-Origin"
}