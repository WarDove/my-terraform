terraform {
  required_version = ">=0.12.29"
  backend s3 {
    region  = "us-west-2"
    profile = "default"
    key     = "tfstatefile"
    bucket  = "tarlantfstate-jenkins"
  }
}
