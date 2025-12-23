terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" 
}

# A simple resource to test the pipeline
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Standard Amazon Linux 2 AMI
  instance_type = var.instance_type

  tags = {
    Name = "Jenkins-Lab-Instance"
  }
}