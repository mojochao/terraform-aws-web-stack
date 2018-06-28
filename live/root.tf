terraform {
  required_version      = ">= 0.11, < 0.12"

  backend "s3" {
    bucket              = "agooch-demo-svc-tfstate"
    key                 = "terraform.tfstate"
    region              = "us-west-2"
  }
}

provider "aws" {
  version               = "~> 1.25"
  alias                 = "usw2"
  region                = "us-west-2"
}

locals {
  tags = {
    System              = "demo-svc"
    Product             = "Demo service"
  }
}

module "prod" {
  source                = "../modules/stack"
  providers = {
    aws                 = "aws.usw2"
  }

  environment           = "prod"
  description           = "Production demo service"
  domain_name           = "demo-svc.samba.tv"
  key_name              = "${var.key_name}"
  maintainer            = "Allen Gooch"
  region                = "us-west-2"
  subnets               = ["subnet-789edf13", "subnet-799edf12", "subnet-7f9edf14"]
  vpc                   = "vpc-7a9edf11"
  db_instance_type      = "db.t2.micro"
  db_size_gb            = 40
  web_instance_ami      = "ami-e6d5969e"
  web_instance_type     = "t2.micro"
  web_instances_desired = 1
  web_instances_max     = 1
  web_instances_min     = 1
  tags                  = "${local.tags}"
}
