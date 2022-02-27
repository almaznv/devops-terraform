
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "avagapov-test-bucket"
    key    = "terraform/state.tfstate"
    region = "eu-central-1"
  }
}