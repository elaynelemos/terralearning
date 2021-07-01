output "clb_dns_name" {
  value       = aws_elb.example.dns_name
  description = "The domain name of the load balancer."
}

output "asg_name" {
  value       = aws_autoscaling_group.exampe.name
  description = "The name of the autoscaling group."
}
