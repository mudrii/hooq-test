output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "gw_id" {
  value = "${module.vpc.gw_id}"
}

output "main_route_table_id" {
  value = "${module.vpc.main_route_table_id}"
}

output "vpc_dhcp_id" {
  value = "${module.vpc.vpc_dhcp_id}"
}

output "subnets" {
  value = ["${module.subnets.subnets}"]
}

output "route_id" {
  value = "${module.route.route_id}"
}

output "sec_grp_front_elb_id" {
  value = "${module.sec_groups.sec_grp_front_elb_id}"
}

output "sec_grp_front_serv_id" {
  value = "${module.sec_groups.sec_grp_front_serv_id}"
}

output "sec_grp_back_elb_id" {
  value = "${module.sec_groups.sec_grp_back_elb_id}"
}

output "sec_grp_back_serv_id" {
  value = "${module.sec_groups.sec_grp_back_serv_id}"
}

output "sec_grp_rds_id" {
  value = "${module.sec_groups.sec_grp_rds_id}"
}

output "sec_grp_redis_id" {
  value = "${module.sec_groups.sec_grp_redis_id}"
}

output "db_subnet_group_id" {
  value = "${module.rds.db_subnet_group_id}"
}

output "db_subnet_group_arn" {
  value = "${module.rds.db_subnet_group_arn}"
}

output "db_instance_address" {
  value = "${module.rds.db_instance_address}"
}

output "db_instance_arn" {
  value = "${module.rds.db_instance_arn}"
}

output "db_instance_availability_zone" {
  value = "${module.rds.db_instance_availability_zone}"
}

output "db_instance_endpoint" {
  value = "${module.rds.db_instance_endpoint}"
}

output "db_instance_id" {
  value = "${module.rds.db_instance_id}"
}

output "db_instance_resource_id" {
  value = "${module.rds.db_instance_resource_id}"
}

output "db_instance_status" {
  value = "${module.rds.db_instance_status}"
}

output "db_instance_name" {
  value = "${module.rds.db_instance_name}"
}

output "db_instance_username" {
  value = "${module.rds.db_instance_username}"
}

output "db_instance_password" {
  value = "${module.rds.db_instance_password}"
}

output "db_instance_port" {
  value = "${module.rds.db_instance_port}"
}

output "redis_subnet_ids" {
  value = "${module.elasticache.redis_subnet_ids}"
}

output "redis_cluster_id" {
  value = "${module.elasticache.redis_cluster_id}"
}

output "redis_cluster_endpoint" {
  value = "${module.elasticache.redis_cluster_endpoint}"
}

output "redis_member_clusters" {
  value = "${module.elasticache.redis_member_clusters}"
}

output "key_sha_front" {
  value = "${module.key_sha.key_sha_front}"
}

output "key_sha_back" {
  value = "${module.key_sha.key_sha_back}"
}

output "elb_front_end_address" {
  value = "${module.elb.elb_front_end_address}"
}

output "elb_front_end_name" {
  value = "${module.elb.elb_front_end_name}"
}

output "elb_back_end_address" {
  value = "${module.elb.elb_back_end_address}"
}

output "elb_back_end_name" {
  value = "${module.elb.elb_back_end_name}"
}

output "front_launch_configuration" {
  value = "${module.autoscaling.front_launch_configuration}"
}

output "front_autoscaling_group" {
  value = "${module.autoscaling.front_autoscaling_group}"
}

output "back_launch_configuration" {
  value = "${module.autoscaling.back_launch_configuration}"
}

output "back_autoscaling_group" {
  value = "${module.autoscaling.back_autoscaling_group}"
}