variable "cluster_name" {
  description = "The cluster name."
}

variable "db_name" {
  description = "Database name."
//  default     = "recommendations"
}

variable "db_password" {
  description = "Database user password."
}

variable "db_size_gb" {
  description = "The allocated storage in GBs."
}

variable "db_username" {
  description = "Database user name."
}

variable "engine" {
  description = "Database engine to use."
  default     = "postgres"
}

variable "engine_version" {
  description = "Version of database engine to use."
  default     = "10"
}

// https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
variable "instance_type" {
  description = "The type of DB EC2 Instances to run database service on."
}

variable "region" {
  description = "Environment region."
}

variable "tags" {
  description = "The tags to apply to AWS resources."
  type        = "map"
}
