provider "aws" {
  region = "${var.region}"
}

#=================================S3 backend====================================

terraform {
  backend "s3" {
    bucket = "aws-backend-es436-commentator-dev" // Bucket where to SAVE Terraform State
    key    = "dev/terraform.tfstate"             // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                         // Region where bycket created
  }
}

#======================================VPC======================================

module "SG" {
  source      = "./modules/SecurityGroup"
  vpc_id      = "${module.network.vpc_id}"
  allow_ports = "${var.allow_ports}"
  env         = "${var.env}"
  project     = "${var.project}"
  sub_project = "${var.sub_project}"
}

module "network" {
  source              = "./modules/network"
  vpc_cidr            = "${var.vpc_cidr}"
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  #private_subnet_cidrs = "${var.private_subnet_cidrs}"
  env         = "${var.env}"
  project     = "${var.project}"
  sub_project = "${var.sub_project}"
}

module "EC2" {
  source               = "./modules/EC2"
  sg_id                = "${module.SG.sg_id}"
  vpc_id               = "${module.network.vpc_id}"
  public_subnet_ids    = "${module.network.public_subnet_ids}"
  iam_name             = "${module.IAM_for_EC2.iam_name}"
  cluster_name         = "${module.ECS.cluster_name}"
  type_instance        = "${var.type_instance}"
  asg_max_size         = "${var.asg_max_size}"
  asg_min_size         = "${var.asg_min_size}"
  asg_desired_capacity = "${var.asg_desired_capacity}"
  key                  = "${var.key}"
  env                  = "${var.env}"
  project              = "${var.project}"
  sub_project          = "${var.sub_project}"
}

module "IAM_for_EC2" {
  source      = "./modules/IAM"
  env         = "${var.env}"
  project     = "${var.project}"
  sub_project = "${var.sub_project}"
}

module "RDS" {
  source                  = "./modules/RDS"
  public_subnet_ids       = "${module.network.public_subnet_ids}"
  engine                  = "${var.engine}"
  engine_version          = "${var.engine_version}"
  instance_class          = "${var.instance_class}"
  allocated_storage       = "${var.allocated_storage}"
  username                = "${var.username}"
  rds_pswd_keeper         = "${var.rds_pswd_keeper}"
  backup_retention_period = "${var.backup_retention_period}"
  vpc_id                  = "${module.network.vpc_id}"
  db_allow_port           = "${var.db_allow_port}"
  env                     = "${var.env}"
  project                 = "${var.project}"
  sub_project             = "${var.sub_project}"
}

module "ECS" {
  source              = "./modules/ECS"
  lb_arn              = "${module.EC2.lb_arn}"
  lb                  = "${module.EC2.lb}"
  public_subnet_names = "${module.network.data_az}"
  count_container     = "${var.count_container}"
  name_container      = "${var.name_container}"
  port_container      = "${var.port_container}"
  env                 = "${var.env}"
  project             = "${var.project}"
  sub_project         = "${var.sub_project}"
}
