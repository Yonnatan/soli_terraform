# VPC Endpoint Service in Peer VPC
resource "aws_vpc_endpoint_service" "service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.nlb.arn]
}

# Network Load Balancer in Peer VPC
resource "aws_lb" "nlb" {
  name               = "nlb${var.name_suffix}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.peer_subnet_ids

  enable_deletion_protection = false
}

# NLB Target Group in Peer VPC
resource "aws_lb_target_group" "tg" {
  name     = "tg${var.name_suffix}"
  port     = 22
  protocol = "TCP"
  vpc_id   = var.peer_vpc_id
}

# NLB Listener in Peer VPC
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Attach EC2 instance to NLB Target Group in Peer VPC
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance_id
  port             = 22
}

# VPC Endpoint in Destination VPC
resource "aws_vpc_endpoint" "endpoint" {
  vpc_id             = var.vpc_id
  service_name       = aws_vpc_endpoint_service.service.service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  tags = {
    Name = "VPC-Endpoint-${var.name_suffix}"
  }
}