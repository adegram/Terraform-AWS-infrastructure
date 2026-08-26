terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.56.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "company-infrastructure-tf-state"
    key    = "company-vpc/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}
