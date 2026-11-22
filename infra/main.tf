# demo-app's infrastructure, deployed by DSW-Poc/reusable-workflows terraform.yml (lesson 0003).
terraform {
  required_version = ">= 1.10" # S3 native locking (use_lockfile)
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.73"
    }
  }

  # Partial backend config: bucket, key and region are passed by the
  # reusable workflow with -backend-config, so no account details live here.
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {}

variable "greeting" {
  description = "Change this and push to main to see plan -> approval -> apply"
  type        = string
  default     = "hello from demo-app v1"
}

resource "aws_ssm_parameter" "greeting" {
  name  = "/demo-app/prod/greeting"
  type  = "String"
  value = var.greeting
}

output "parameter_name" { value = aws_ssm_parameter.greeting.name }
