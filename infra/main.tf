terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }
    backend "s3" {
    bucket   = "rmit-tfstate-tb0nyr"
    key    = "assignment-2/infra-deployment"
    region     = "us-east-1"
    dynamodb_endpoint = "https://dynamodb.us-east-1.amazonaws.com"
    dynamodb_table = "rmit-locktable-tb0nyr"

  }
}


provider "aws" {
  region = "us-east-1"
}
