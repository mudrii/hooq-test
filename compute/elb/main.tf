# Create a new load balancer
resource "aws_elb" "elb_front_end" {
  name = "elb-front-end"

  security_groups = [
    "${var.sec_grp_front_elb_id}",
  ]

  subnets = ["${var.subnets}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  internal                    = false
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_elb" "elb_back_end" {
  name = "elb-back-end"

  security_groups = [
    "${var.sec_grp_back_elb_id}",
  ]

  subnets = ["${var.subnets}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  internal                    = true
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${terraform.workspace}"
  }
}
