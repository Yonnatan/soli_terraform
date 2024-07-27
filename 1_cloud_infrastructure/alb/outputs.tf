output "alb_name" {
  value = aws_lb.main.name
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_listener_arn" {
  value = aws_lb_listener.http.arn
}