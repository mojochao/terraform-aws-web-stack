variable "tags" {
  description = "The tags to apply to AWS resources."
  type        = "map"
}

variable "subnets" {
  description = "Subnets to use."
  type        = "list"
  default     = [
    "subnet-789edf13",
    "subnet-799edf12",
    "subnet-7f9edf14"
  ]
}

variable "vpc_id" {
  description = "VPC to use."
  default     = "vpc-7a9edf11"
}
