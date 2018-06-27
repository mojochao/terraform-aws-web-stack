locals {
  subnets = [
    "subnet-789edf13",
    "subnet-799edf12",
    "subnet-7f9edf14"
  ]
  vpc_id                  = "vpc-7a9edf11"
}

module "web" {
  source           = "../../../modules/web"
  environment      = "prod"
  region           = "us-west-2"
  maintainer       = "Allen Gooch"
  description      = "terraform-aws-web-stack demo service"
  source_ami       = "ami-e6d5969e"
  instance_type    = "c5.xlarge"
  min_size         = 1
  max_size         = 1
  subnets          = "${local.subnets}"
  vpc_id           = "${local.vpc_id}"
  tags             = "${var.tags}"
}
