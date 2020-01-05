variable "allocated_storage" {
  default = "20"
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "8.0.16"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "username" {
  default = "superuser"
}

variable "backup_retention_period" {
  default = "0"
}

variable "rds_pswd_keeper" {
  description = "Password keeper"
  default     = "owner"
}

variable "public_subnet_ids" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "env" {
  default = "test"
}
