resource "aws_elasticache_subnet_group" "elasticache" {
  name       = "redis-cache"
  subnet_ids = ["${var.subnets}"]
}

resource "aws_elasticache_replication_group" "elasticache_rep_grp" {
  replication_group_id          = "replica-group"
  replication_group_description = "redis replication group"
  engine_version                = "5.0.0"
  node_type                     = "cache.m1.small"
  number_cache_clusters         = 2
  port                          = 6379
  parameter_group_name          = "default.redis5.0"
  subnet_group_name             = "${aws_elasticache_subnet_group.elasticache.id}"

  security_group_ids = [
    "${var.sec_grp_redis_id}",
  ]

  automatic_failover_enabled = true
  auto_minor_version_upgrade = true
  apply_immediately          = true

  tags {
    Name = "${terraform.workspace}"
  }
}
