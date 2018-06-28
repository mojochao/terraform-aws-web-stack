variable "ami" {
  description = "The AMI to use."
}

variable "cluster_name" {
  description = "The cluster name."
}

variable "desired_size" {
  description = "The desired number of EC2 Instances in the ASG."
}

variable "domain_name" {
  description = "Environment domain name."
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
