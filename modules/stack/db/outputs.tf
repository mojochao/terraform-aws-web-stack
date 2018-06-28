output "db_host" {
  value = "${aws_db_instance.backend.address}"
}

output "db_port" {
  value = "${aws_db_instance.backend.port}"
}
