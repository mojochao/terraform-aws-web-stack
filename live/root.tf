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
  tags = {
    System         = "demo-svc"
    Product        = "Demo service"
    Maintainer     = "Allen Gooch"
  }
}

module "prod" {
  source           = "./prod"
  tags             = "${local.tags}"
  providers = {
    aws            = "aws.usw2"
  }
}
