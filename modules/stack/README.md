# Stack Module

This module contains the Terraform configuration for a stack consisting of
database and web service tiers in AWS.

It is composed of the `db` and `web` submodules.

It builds the following AWS resources:

- an RDS PostgreSQL database
- an application load balancer
- an autoscaling group
- security groups for load balancer and autoscaling group ec2 instances

It requires the following inputs:

- description
- domain_name
- environment
- key_name
- maintainer
- region
- subnets
- vpc
- db_instance_type
- db_size_gb
- web_instance_ami
- web_instance_type
- web_instances_desired
- web_instances_max
- web_instances_min

It provides the following outputs:

- db.db_host
- db.db_port
- web.alb_dns_name
- web.alb_security_group_id
- web.asg_name
