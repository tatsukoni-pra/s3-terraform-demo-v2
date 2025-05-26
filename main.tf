terraform {
  required_version = "1.7.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.43.0"
    }
  }
  backend "s3" {
    bucket  = "tatsukoni-tfstates"
    key     = "aws/s3/v2/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "tatsukoni"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "tatsukoni"
}
