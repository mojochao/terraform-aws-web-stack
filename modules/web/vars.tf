variable "environment" {
  description = "Environment name"
}

variable "region" {
  description = "Environment region"
}

variable "maintainer" {
  description = "Environment maintainer."
}

variable "description" {
  description = "Environment description."
}

variable "source_ami" {
  description = "AMI to use."
}

variable "instance_type" {
  description = "The type of EC2 Instances to run in the ASG."
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG."
  default     = 1
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG."
  default     = 1
}

variable "tags" {
  description = "The tags to apply to AWS resources."
  type        = "map"
}

variable "subnets" {
  description = "EC2 instance subnets."
  type        = "list"
}

variable "vpc_id" {
  description = "EC2 VPC id."
}
