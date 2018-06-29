locals {
  cluster_name  = "${local.tags["System"]}-${var.environment}"
  key_name      = "samba@cloudserver"
  ssl_policy    = "ELBSecurityPolicy-TLS-1-2-2017-01"
  tags = {
    System      = "recs-api"
    Product     = "Recommendations API"
    Description = "${var.description}"
    Environment = "${var.environment}"
    Maintainer  = "${var.maintainer}"
  }
}

//module "db" {
//  source        = "./db"
//
//  cluster_name  = "${local.cluster_name}"
//  db_name       = "postgres"
//  db_password   = "postgres"
//  db_size_gb    = "${var.db_size_gb}"
//  db_username   = "postgres"
//  instance_type = "${var.db_instance_type}"
//  region        = "${var.region} "
//  tags          = "${merge(var.tags, local.tags)}"
//}

module "web" {
  source        = "./web"

  ami           = "${var.web_instance_ami}"
  cluster_name  = "${local.cluster_name}"
  desired_size  = "${var.web_instances_desired}"
  domain_name   = "${var.domain_name}"
  instance_type = "${var.web_instance_type}"
  key_name      = "${local.key_name}"
  max_size      = "${var.web_instances_max}"
  min_size      = "${var.web_instances_min}"
  region        = "${var.region} "
  ssl_policy    = "${local.ssl_policy}"
  subnets       = "${var.subnets}"
  tags          = "${local.tags}"
  vpc           = "${var.vpc}"
}
