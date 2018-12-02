output "redis_subnet_ids" {
  value = "${aws_elasticache_subnet_group.elasticache.subnet_ids}"
}

output "redis_cluster_id" {
  value = "${aws_elasticache_replication_group.elasticache_rep_grp.id}"
}

output "redis_cluster_endpoint" {
  value = "${aws_elasticache_replication_group.elasticache_rep_grp.primary_endpoint_address}"
}

output "redis_member_clusters" {
  value = "${aws_elasticache_replication_group.elasticache_rep_grp.member_clusters}"
}
