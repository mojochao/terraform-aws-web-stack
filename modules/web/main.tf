data "aws_availability_zones" "all" {}

locals {
  cluster_name            = "${var.tags["System"]}-${var.environment}"
  http_port               = 80
  ssh_port                = 22
  tags = {
    Description           = "${var.description}"
    Environment           = "${var.environment}"
    Owner                 = "${var.owner}"
  }
}

#------------------------------------------------------------------------------
# Back-end Auto-scaling Group (ASG) Resources
#------------------------------------------------------------------------------

resource "aws_launch_configuration" "backend" {
  name                    = "${local.cluster_name}-launch-configuration"
  image_id                = "${var.source_ami}"
  instance_type           = "${var.instance_type}"
  security_groups         = ["${aws_security_group.backend.id}"]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p "${local.http_port}" &
            EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend" {
  name                    = "${local.cluster_name}-asg"
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
      key                 = "Environment"
      value               = "${local.tags["Environment"]}"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "${local.tags["Owner"]}"
      propagate_at_launch = true
    },
    {
      key                 = "Description"
      value               = "${local.tags["Description"]}"
      propagate_at_launch = true
    }
  ]
}

resource "aws_security_group" "backend" {
  name                    = "${local.cluster_name}-backend-sg"
  tags                    = "${merge(var.tags, local.tags)}"

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

#------------------------------------------------------------------------------
# Front-end Application Load Balancer (ALB) Resources
#------------------------------------------------------------------------------

resource "aws_alb" "frontend" {
  name                    = "${local.cluster_name}-alb"
  internal                = false
  load_balancer_type      = "application"
  subnets                 = "${var.subnets}"
  security_groups         = ["${aws_security_group.frontend.id}"]
  idle_timeout            = "60"
  tags                    = "${merge(var.tags, local.tags)}"
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
  name                    = "${local.cluster_name}-alb"
  port                    = "${local.http_port}"
  protocol                = "HTTP"
  vpc_id                  = "${var.vpc_id}"
  tags                    = "${merge(var.tags, local.tags)}"

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

resource "aws_security_group" "frontend" {
  name                    = "${local.cluster_name}-frontend-sg"
  tags                    = "${merge(var.tags, local.tags)}"
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
