# Web Module

This module contains the Terraform configuration for the web tier of the
`stack` module.

It builds the following AWS resources:

- an application load balancer
- an autoscaling group with launch configuration
- security groups for load balancer and autoscaling group ec2 instances

It requires the following inputs:

- ami
- cluster_name
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

- alb_dns_name
- alb_security_group_id
- asg_name
