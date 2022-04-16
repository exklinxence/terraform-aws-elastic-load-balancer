terraform {
  cloud {
    organization = "klinz-pluralsight"

    workspaces {
      name = "aws-networking-deep-dive-elb-02"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.4.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.3.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
  }

}

provider "aws" {
  region = var.aws_region
}


