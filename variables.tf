variable "allow_ports" {
  value = ["80", "22"]
}

variable "vpc_cidr" {
  value = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  value = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "type_instance" {
  value = "t2.micro"
}

variable key "" {
  value = "Oregon-DevOps-Lab"
}

variable "count_container" {
  value = "1"
}

variable "name_container" {
  value = "Apache"
}

variable "port_container" {
  value = "80"
}

variable "asg_max_size" {
  default = "1"
}

variable "asg_min_size" {
  default = "1"
}

variable "asg_desired_capacity" {
  default = "1"
}
