output "sec_grp_front_elb_id" {
  value = "${aws_security_group.sec_grp_front_elb.id}"
}

output "sec_grp_front_serv_id" {
  value = "${aws_security_group.sec_grp_front_serv.id}"
}

output "sec_grp_back_elb_id" {
  value = "${aws_security_group.sec_grp_back_elb.id}"
}

output "sec_grp_back_serv_id" {
  value = "${aws_security_group.sec_grp_back_serv.id}"
}

output "sec_grp_rds_id" {
  value = "${aws_security_group.sec_grp_rds.id}"
}

output "sec_grp_redis_id" {
  value = "${aws_security_group.sec_grp_redis.id}"
}
