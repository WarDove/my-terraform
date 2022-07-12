terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }
}

provider "aws" {
  provider = var.profile
  region = var.region-master
  alias = "region-master"
}

provider "aws" {
  provider = var.profile
  region = var.region-worker
  alias = "region-worker"
}
