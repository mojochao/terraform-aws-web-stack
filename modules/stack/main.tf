locals {
  cluster_name  = "${var.tags["System"]}-${var.environment}"
  tags = {
    Description = "${var.description}"
    Environment = "${var.environment}"
    Maintainer  = "${var.maintainer}"
  }
}

module "db" {
  source        = "./db"

  cluster_name  = "${local.cluster_name}"
  db_name       = "postgres"
  db_password   = "postgres"
  db_size_gb    = "${var.db_size_gb}"
  db_username   = "postgres"
  instance_type = "${var.db_instance_type}"
  region        = "${var.region} "
  tags          = "${merge(var.tags, local.tags)}"
}

module "web" {
  source        = "./web"

  ami           = "${var.ami}"
  cluster_name  = "${local.cluster_name}"
  desired_size  = "${var.desired_size}"
  domain_name   = "${var.domain_name}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  max_size      = "${var.max_size}"
  min_size      = "${var.min_size}"
  region        = "${var.region} "
  ssl_policy    = "${var.ssl_policy}"
  subnets       = "${var.subnets}"
  tags          = "${merge(var.tags, local.tags)}"
  vpc           = "${var.vpc}"
}
