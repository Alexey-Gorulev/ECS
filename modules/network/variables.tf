variable "vpc_cidr" {
  default = ""
}

variable "public_subnet_cidrs" {
  default = [""]
}

variable "private_subnet_cidrs" {
  default = [""]
}

variable "env" {
  default = ""
}
