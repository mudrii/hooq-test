resource "aws_security_group" "sec_grp_front_elb" {
  name        = "front-end-elb"
  description = "front end elb securety group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_security_group" "sec_grp_front_serv" {
  name        = "front-end-server"
  description = "front server securety group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.sec_grp_front_elb.id}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_security_group" "sec_grp_back_elb" {
  name        = "back-end-elb"
  description = "back end elb securety group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.sec_grp_front_serv.id}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${var.vpc_cidr_block}",
    ]
  }

  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_security_group" "sec_grp_back_serv" {
  name        = "back-end-server"
  description = "back end server securety group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.sec_grp_back_elb.id}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_security_group" "sec_grp_rds" {
  name        = "sec-grp-rds"
  description = "rds securety group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.sec_grp_back_serv.id}",
    ]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.sec_grp_back_serv.id}",
    ]
  }

  tags {
    Name = "${terraform.workspace}"
  }
}

resource "aws_security_group" "sec_grp_redis" {
  name        = "sec-grp-redis"
  description = "redis securety group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.sec_grp_back_serv.id}",
    ]
  }

  egress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.sec_grp_back_serv.id}",
    ]
  }

  tags {
    Name = "${terraform.workspace}"
  }
}
