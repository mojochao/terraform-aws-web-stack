resource "aws_db_instance" "backend" {
  identifier          = "${var.cluster_name}"
  engine              = "${var.engine}"
  engine_version      = "${var.engine_version}"
  allocated_storage   = "${var.db_size_gb}"
  instance_class      = "${var.instance_type}"
  name                = "${var.db_name}"
  username            = "${var.db_username}"
  password            = "${var.db_password}"
  skip_final_snapshot = true
  tags                = "${var.tags}"
}
