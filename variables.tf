variable "region" {
  default = "us-east-1"
}

#=====Security Group

variable "allow_ports" {
  default = ["80", "81", "82", "83", "84", "85", "22"]
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
  default = "t3.medium"
}

variable "key" {
  default = "N.Virginia"
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

#=====EC2

variable "asg_max_size" {
  default = "2"
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
  default = "5.7"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "username" {
  default = "dbadmin"
}

variable "db_allow_port" {
  default = "3306"
}

variable "backup_retention_period" {
  default = "8"
}

variable "rds_pswd_keeper" {
  description = "Password keeper"
  default     = "dbadmin"
}

#=====Tags

variable "env" {
  default = "dev"
}

variable "project" {
  default = "ES436"
}

variable "sub_project" {
  default = "commentator"
}
