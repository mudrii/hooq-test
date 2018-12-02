resource "aws_launch_configuration" "config_front" {
  image_id      = "ami-01bbe152bf19d0289"
  instance_type = "t2.micro"

  security_groups = [
    "${var.sec_grp_front_serv_id}",
  ]

  user_data                   = "${file("./front_end_data.sh")}"
  key_name                    = "${var.key_sha_front}"
  associate_public_ip_address = false
  enable_monitoring           = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "auto_front" {
  vpc_zone_identifier = [
    "${var.subnets}",
  ]

  max_size             = "2"
  min_size             = "1"
  desired_capacity     = "1"
  health_check_type    = "ELB"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.config_front.name}"

  load_balancers = [
    "${var.elb_front_end_name}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "policy-front-mem-scale-up" {
  name                   = "front-mem-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_front.name}"
}

resource "aws_autoscaling_policy" "policy-front-mem-scale-down" {
  name                   = "front-mem-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_front.name}"
}

resource "aws_cloudwatch_metric_alarm" "front-memory-high" {
  alarm_name          = "front-mem-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 memory for high utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-front-mem-scale-up.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_front.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "front-memory-low" {
  alarm_name          = "front-mem-util-low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 memory for low utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-front-mem-scale-down.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_front.name}"
  }
}

resource "aws_autoscaling_policy" "policy-front-cpu-scale-up" {
  name                   = "front-cpu-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_front.name}"
}

resource "aws_autoscaling_policy" "policy-front-cpu-scale-down" {
  name                   = "front-cpu_scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_front.name}"
}

resource "aws_cloudwatch_metric_alarm" "front-cpu-high" {
  alarm_name          = "front-cpu-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu for high utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-front-cpu-scale-up.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_front.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "front-cpu-low" {
  alarm_name          = "front-cpu-util-low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 cpu for low utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-front-cpu-scale-down.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_front.name}"
  }
}

resource "aws_launch_configuration" "config_back" {
  image_id      = "ami-01bbe152bf19d0289"
  instance_type = "t2.micro"

  security_groups = [
    "${var.sec_grp_back_serv_id}",
  ]

  user_data                   = "${file("./back_end_data.sh")}"
  key_name                    = "${var.key_sha_back}"
  associate_public_ip_address = false
  enable_monitoring           = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "auto_back" {
  vpc_zone_identifier = [
    "${var.subnets}",
  ]

  max_size             = "2"
  min_size             = "1"
  desired_capacity     = "1"
  health_check_type    = "ELB"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.config_front.name}"

  load_balancers = [
    "${var.elb_back_end_name}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "policy-back-mem-scale-up" {
  name                   = "back-mem-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_back.name}"
}

resource "aws_autoscaling_policy" "policy-back-mem-scale-down" {
  name                   = "back-mem-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_back.name}"
}

resource "aws_cloudwatch_metric_alarm" "back-memory-high" {
  alarm_name          = "back-mem-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 memory for high utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-back-mem-scale-up.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_back.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "back-memory-low" {
  alarm_name          = "back-mem-util-low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 memory for low utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-back-mem-scale-down.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_back.name}"
  }
}

resource "aws_autoscaling_policy" "policy-back-cpu-scale-up" {
  name                   = "back-cpu-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_back.name}"
}

resource "aws_autoscaling_policy" "policy-back-cpu-scale-down" {
  name                   = "back-cpu_scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_back.name}"
}

resource "aws_cloudwatch_metric_alarm" "back-cpu-high" {
  alarm_name          = "back-cpu-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu for high utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-back-cpu-scale-up.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_back.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "back-cpu-low" {
  alarm_name          = "back-cpu-util-low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 cpu for low utilization on agent hosts"

  alarm_actions = [
    "${aws_autoscaling_policy.policy-back-cpu-scale-down.arn}",
  ]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_back.name}"
  }
}
