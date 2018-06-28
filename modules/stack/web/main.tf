data "aws_availability_zones" "all" {}

locals {
  http_port               = 80
  ssh_port                = 22
}

#------------------------------------------------------------------------------
# Web Frontend Resources
#------------------------------------------------------------------------------

//# DNS resources
//
//resource "aws_route53_zone" "frontend" {
//  name                    = "${var.domain_name}."
//  tags                    = "${var.tags}"
//}
//
//resource "aws_route53_record" "cert_validation" {
//  name                    = "${aws_acm_certificate.frontend.domain_validation_options.0.resource_record_name}"
//  type                    = "${aws_acm_certificate.frontend.domain_validation_options.0.resource_record_type}"
//  zone_id                 = "${aws_route53_zone.frontend.id}"
//  records                 = ["${aws_acm_certificate.frontend.domain_validation_options.0.resource_record_value}"]
//  ttl                     = 60
//}
//
//# SSL certificate resources
//
//resource "aws_acm_certificate" "frontend" {
//  domain_name             = "${var.domain_name}"
//  validation_method       = "DNS"
//  tags                    = "${var.tags}"
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}
//
//resource "aws_acm_certificate_validation" "frontend" {
//  certificate_arn         = "${aws_acm_certificate.frontend.arn}"
//  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
//}

# Load balancer resources

resource "aws_alb" "frontend" {
  name                    = "${var.cluster_name}-alb"
  internal                = false
  load_balancer_type      = "application"
  subnets                 = "${var.subnets}"
  security_groups         = ["${aws_security_group.frontend.id}"]
  idle_timeout            = "60"
  tags                    = "${var.tags}"
}

resource "aws_alb_listener" "frontend" {
  load_balancer_arn       = "${aws_alb.frontend.arn}"
  port                    = "${local.http_port}"
  protocol                = "HTTP"

  default_action {
    target_group_arn      = "${aws_alb_target_group.frontend.arn}"
    type                  = "forward"
  }
}

resource "aws_alb_listener_rule" "frontend" {
  depends_on              = ["aws_alb_target_group.frontend"]
  listener_arn            = "${aws_alb_listener.frontend.arn}"

  action {
    target_group_arn      = "${aws_alb_target_group.frontend.arn}"
    type                  = "forward"
  }

  condition {
    field                 = "host-header"
    values                = ["*.*"]
  }
}

resource "aws_alb_target_group" "frontend" {
  name                    = "${var.cluster_name}-alb"
  port                    = "${local.http_port}"
  protocol                = "HTTP"
  vpc_id                  = "${var.vpc}"
  tags                    = "${var.tags}"

  health_check {
    healthy_threshold     = 2
    unhealthy_threshold   = 2
    timeout               = 3
    interval              = 30
    port                  = "${local.http_port}"
    protocol              = "HTTP"
    path                  = "/"
  }
}

# Frontend security group resources

resource "aws_security_group" "frontend" {
  name                    = "${var.cluster_name}-frontend-sg"
  tags                    = "${var.tags}"
}

resource "aws_security_group_rule" "frontend_allow_http_inbound" {
  type                    = "ingress"
  security_group_id       = "${aws_security_group.frontend.id}"
  from_port               = "${local.http_port}"
  to_port                 = "${local.http_port}"
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_allow_all_outbound" {
  type                    = "egress"
  security_group_id       = "${aws_security_group.frontend.id}"
  from_port               = 0
  to_port                 = 0
  protocol                = "-1"
  cidr_blocks             = ["0.0.0.0/0"]
}

#------------------------------------------------------------------------------
# Web Backend Resources
#------------------------------------------------------------------------------

# Launch configuration resources

resource "aws_launch_configuration" "backend" {
  name_prefix             = "${var.cluster_name}-lc"
  image_id                = "${var.ami}"
  instance_type           = "${var.instance_type}"
  security_groups         = ["${aws_security_group.backend.id}"]
  key_name                = "${var.key_name}"
  user_data = <<-EOF
              #!/bin/bash
              apt-get install nginx -y
              # echo "Hello from `hostname`" > /var/www/html/index.nginx-debian.html
              echo "Hello from `hostname`" > /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling group resources

resource "aws_autoscaling_group" "backend" {
  name                    = "${var.cluster_name}-asg"
  launch_configuration    = "${aws_launch_configuration.backend.id}"
  availability_zones      = ["${data.aws_availability_zones.all.names}"]
  target_group_arns       = ["${aws_alb_target_group.frontend.arn}"]
  min_size                = "${var.min_size}"
  max_size                = "${var.max_size}"
  tags = [
    {
      key                 = "System"
      value               = "${var.tags["System"]}"
      propagate_at_launch = true
    },
    {
      key                 = "Product"
      value               = "${var.tags["Product"]}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.tags["Environment"]}"
      propagate_at_launch = true
    },
    {
      key                 = "Maintainer"
      value               = "${var.tags["Maintainer"]}"
      propagate_at_launch = true
    },
    {
      key                 = "Description"
      value               = "${var.tags["Description"]}"
      propagate_at_launch = true
    }
  ]
}

# Backend security group resources

resource "aws_security_group" "backend" {
  name                    = "${var.cluster_name}-backend-sg"
  tags                    = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "backend_allow_http_inbound" {
  type                    = "ingress"
  security_group_id       = "${aws_security_group.backend.id}"
  from_port               = "${local.http_port}"
  to_port                 = "${local.http_port}"
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "backend_allow_ssh_inbound" {
  type                    = "ingress"
  security_group_id       = "${aws_security_group.backend.id}"
  from_port               = "${local.ssh_port}"
  to_port                 = "${local.ssh_port}"
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "backend_allow_all_outbound" {
  type                    = "egress"
  security_group_id       = "${aws_security_group.backend.id}"
  from_port               = 0
  to_port                 = 0
  protocol                = "-1"
  cidr_blocks             = ["0.0.0.0/0"]
}
