terraform {
  backend "s3" {
    bucket = "hooq.terra-state-bucket"
    key    = "tfstate"
    region = "us-west-2"
  }
}
