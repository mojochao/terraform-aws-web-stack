output "alb_dns_name" {
  value = "${aws_alb.frontend.dns_name}"
}

output "alb_security_group_id" {
  value = "${aws_security_group.frontend.id}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.backend.name}"
}
