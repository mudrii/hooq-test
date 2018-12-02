output "key_sha_front" {
  value = "${aws_key_pair.key_sha_front.key_name}"
}

output "key_sha_back" {
  value = "${aws_key_pair.key_sha_back.key_name}"
}
