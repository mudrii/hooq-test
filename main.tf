terraform {
  required_version = "~> 0.11.10"
}

# Specify the provider and access details
provider "aws" {
  version    = "~> 1.50"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

## Network
# Create VPC
module "vpc" {
  source     = "./network/vpc"
  cidr_block = "${var.cidr_block}"
}

# Create Subnets
module "subnets" {
  source         = "./network/subnets"
  vpc_id         = "${module.vpc.vpc_id}"
  vpc_cidr_block = "${module.vpc.vpc_cidr_block}"
}

# Configure Routes
module "route" {
  source              = "./network/route"
  main_route_table_id = "${module.vpc.main_route_table_id}"
  gw_id               = "${module.vpc.gw_id}"

  subnets = [
    "${module.subnets.subnets}",
  ]
}

module "sec_groups" {
  source         = "./network/sec_groups"
  vpc_id         = "${module.vpc.vpc_id}"
  vpc_cidr_block = "${module.vpc.vpc_cidr_block}"
}

module "rds" {
  source = "./rds"

  subnets = [
    "${module.subnets.subnets}",
  ]

  sec_grp_rds_id    = "${module.sec_groups.sec_grp_rds_id}"
  identifier        = "${var.identifier}"
  storage_type      = "${var.storage_type}"
  allocated_storage = "${var.allocated_storage}"
  db_engine         = "${var.db_engine}"
  engine_version    = "${var.engine_version}"
  instance_class    = "${var.instance_class}"
  db_username       = "${var.db_username}"
  db_password       = "${var.db_password}"
}

module "elasticache" {
  source = "./elasticache"

  subnets = [
    "${module.subnets.subnets}",
  ]

  sec_grp_redis_id = "${module.sec_groups.sec_grp_redis_id}"
}

module "key_sha" {
  source        = "./compute/ec2_keys"
  key_sha_front = "${var.key_sha_front}"
  key_sha_back  = "${var.key_sha_back}"
}

module "elb" {
  source = "./compute/elb"

  subnets = [
    "${module.subnets.subnets}",
  ]

  sec_grp_front_elb_id = "${module.sec_groups.sec_grp_front_elb_id}"
  sec_grp_back_elb_id  = "${module.sec_groups.sec_grp_back_elb_id}"
}

module "autoscaling" {
  source = "./compute/autoscaling"

  subnets = [
    "${module.subnets.subnets}",
  ]

  sec_grp_front_serv_id  = "${module.sec_groups.sec_grp_front_serv_id}"
  sec_grp_back_serv_id = "${module.sec_groups.sec_grp_back_serv_id}"
  key_sha_front          = "${module.key_sha.key_sha_front}"
  key_sha_back           = "${module.key_sha.key_sha_back}"
  elb_front_end_name     = "${module.elb.elb_front_end_name}"
  elb_back_end_name      = "${module.elb.elb_back_end_name}"
}
