terraform {
    required_version = "~> 1.12.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

provider "aws" {
  # Configuration options
  default_tags {
    tags = {
      OwnedBy = "OilyGooseStudio"
      ManagedBy = "Terraform"
    }
  }
}