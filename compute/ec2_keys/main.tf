resource "aws_key_pair" "key_sha_front" {
  key_name   = "key-sha-front"
  public_key = "${var.key_sha_front}"
}

resource "aws_key_pair" "key_sha_back" {
  key_name   = "key-sha-back"
  public_key = "${var.key_sha_back}"
}
