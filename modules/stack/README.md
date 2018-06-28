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

- ami
- cluster_name
- db_size_gb
- db_instance_type
- desired_size
- domain_name
- instance_type
- key_name
- min_size
- max_size
- region
- ssl_policy
- subnets
- tags
- vpc

It provides the following outputs:

- db.db_host
- db.db_port
- web.alb_dns_name
- web.alb_security_group_id
- web.asg_name
