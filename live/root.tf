terraform {
  required_version = ">= 0.11, < 0.12"

  backend "s3" {
    bucket         = "agooch-demo-svc-tfstate"
    key            = "terraform.tfstate"
    region         = "us-west-2"
  }
}

provider "aws" {
  version          = "~> 1.25"
  alias            = "usw2"
  region           = "us-west-2"
}

provider "template" {
  version          = "~> 1.0"
}

locals {
  ssl_policy       = "ELBSecurityPolicy-TLS-1-2-2017-01"
  tags = {
    System         = "demo-svc"
    Product        = "Demo service"
  }
}

module "prod" {
  source           = "../modules/stack"
  providers = {
    aws            = "aws.usw2"
  }

  ami              = "ami-e6d5969e"
  db_instance_type = "db.t2.micro"
  db_size_gb       = 40
  environment      = "prod"
  description      = "Production demo service"
  desired_size     = 1
  domain_name      = "demo-svc.samba.tv"
  instance_type    = "t2.micro"
  key_name         = "samba@cloudserver"
  maintainer       = "Allen Gooch"
  max_size         = 1
  min_size         = 1
  region           = "us-west-2"
  ssl_policy       = "${local.ssl_policy}"
  subnets          = ["subnet-789edf13", "subnet-799edf12", "subnet-7f9edf14"]
  tags             = "${local.tags}"
  vpc              = "vpc-7a9edf11"
}
