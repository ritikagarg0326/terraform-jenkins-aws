output "dns_name" {
  value = aws_lb.this.dns_name
}

output "load_balancer_arn" {
  value = aws_lb.this.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.jenkins.arn
}

output "jenkins_url" {
  value = "http://${aws_lb.this.dns_name}"
}
