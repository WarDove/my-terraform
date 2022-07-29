# root providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region-bck
  alias   = "region-bck"
}

provider "aws" {
  profile = var.profile
  region  = var.region-1
  alias   = "region-1"
}

provider "aws" {
  profile = var.profile
  region  = var.region-2
  alias   = "region-2"
}
