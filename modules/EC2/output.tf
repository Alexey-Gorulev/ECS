output "lb_arn" {
  value = aws_lb_target_group.test.arn
}

output "lb" {
  value = aws_lb.test
}

output "alb_dns_name" {
  value = aws_lb.test.dns_name
}
