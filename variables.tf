variable "region" {
  default = "us-west-2"
}

#=====Security Group

variable "allow_ports" {
  default = ["80", "22"]
}

#=====Network

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
/*
variable "private_subnet_cidrs" {
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}
*/
variable "type_instance" {
  default = "t2.micro"
}

variable "key" {
  default = "Oregon-DevOps-Lab"
}

#=====ECS

variable "count_container" {
  default = "1"
}

variable "name_container" {
  default = "Apache"
}

variable "port_container" {
  default = "80"
}

variable "asg_max_size" {
  default = "3"
}

variable "asg_min_size" {
  default = "1"
}

variable "asg_desired_capacity" {
  default = "1"
}

#=====RDS

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

variable "db_allow_port" {
  default = "3306"
}

variable "backup_retention_period" {
  default = "0"
}

variable "rds_pswd_keeper" {
  description = "Password keeper"
  default     = "owner"
}

#=====Tags

variable "env" {
  default = "test"
}

variable "project" {
  default = "test_projet"
}

variable "sub_project" {
  default = "test_sub_projet"
}
