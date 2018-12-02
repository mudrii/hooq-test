output "front_launch_configuration" {
  value = "${aws_launch_configuration.config_front.id}"
}

output "front_autoscaling_group" {
  value = "${aws_autoscaling_group.auto_front.id}"
}

output "back_launch_configuration" {
  value = "${aws_launch_configuration.config_back.id}"
}

output "back_autoscaling_group" {
  value = "${aws_autoscaling_group.auto_back.id}"
}