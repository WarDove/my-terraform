terraform {
  required_version = ">=1.2.4"
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "tfstatefile"
    bucket  = "tarlantfstate"
   # dynamodb_table = "tfstate-lock" #comment this during provisioning from 0, otherwise state will remain locked
  }
}
