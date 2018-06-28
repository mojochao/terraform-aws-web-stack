variable "ami" {
  description = "The AMI to use."
}

variable "db_instance_type" {
  description = "Database instance type."
}

variable "db_size_gb" {
  description = "Database size in gigabytes."
}

variable "description" {
  description = "Environment description."
}

variable "desired_size" {
  description = "The desired number of EC2 Instances in the ASG."
}

variable "domain_name" {
  description = "Environment domain name."
}

variable "environment" {
  description = "Environment name."
}

variable "instance_type" {
  description = "The type of EC2 Instances to run in the ASG."
}

variable "key_name" {
  description = "SSH key to use."
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG."
}

variable "maintainer" {
  description = "Environment maintainer."
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG."
}

variable "region" {
  description = "Environment region."
}

variable "ssl_policy" {
  description = "The SSL policy to use."
}

variable "subnets" {
  description = "EC2 instance subnets."
  type        = "list"
}

variable "tags" {
  description = "The tags to apply to AWS resources."
  type        = "map"
}

variable "vpc" {
  description = "The VPC to use."
}
