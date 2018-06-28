variable "db_instance_type" {
  description = "Database instance type."
}

variable "db_size_gb" {
  description = "Database size in gigabytes."
}

variable "description" {
  description = "Environment description."
}

variable "domain_name" {
  description = "Environment domain name."
}

variable "environment" {
  description = "Environment name."
}

variable "maintainer" {
  description = "Environment maintainer."
}

variable "region" {
  description = "Environment region."
}

variable "subnets" {
  description = "EC2 instance subnets."
  type        = "list"
}

variable "web_instance_ami" {
  description = "The AMI to use when launching EC2 instances running in the ASG."
}

variable "web_instance_key_name" {
  description = "The SSH key to use when connecting to EC2 instances running in the ASG."
}

variable "web_instance_type" {
  description = "The type of EC2 instances to run in the ASG."
}

variable "web_instances_desired" {
  description = "The desired number of EC2 instances in the ASG."
}

variable "web_instances_max" {
  description = "The maximum number of EC2 instances in the ASG."
}

variable "web_instances_min" {
  description = "The minimum number of EC2 instances in the ASG."
}

variable "vpc" {
  description = "The VPC to use."
}
