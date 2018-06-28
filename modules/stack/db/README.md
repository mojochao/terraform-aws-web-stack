# Database Module

This module contains the Terraform configuration for the database tier of the
`stack` module.

It builds the following AWS resources:

- an RDS PostgreSQL database

It requires the following inputs:

- cluster_name
- db_name
- db_password
- db_size_gb
- db_username
- engine
- engine_version
- instance_type
- region
- tags

It provides the following outputs:

- db_host
- db_port
