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

variable "key_name" {
  description = "SSH key to use."
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

variable "tags" {
  description = "The tags to apply to AWS resources."
  type        = "map"
}

variable "web_instance_ami" {
  description = "The AMI to use."
}

variable "web_instance_type" {
  description = "The type of EC2 Instances to run in the ASG."
}

variable "web_instances_desired" {
  description = "The desired number of EC2 Instances in the ASG."
}

variable "web_instances_max" {
  description = "The maximum number of EC2 Instances in the ASG."
}

variable "web_instances_min" {
  description = "The minimum number of EC2 Instances in the ASG."
}

variable "vpc" {
  description = "The VPC to use."
}
