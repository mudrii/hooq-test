output "elb_front_end_address" {
  value = "${aws_elb.elb_front_end.dns_name}"
}

output "elb_front_end_name" {
  value = "${aws_elb.elb_front_end.name}"
}

output "elb_back_end_address" {
  value = "${aws_elb.elb_back_end.dns_name}"
}

output "elb_back_end_name" {
  value = "${aws_elb.elb_back_end.name}"
}
