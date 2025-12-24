# main.tf
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "splunk_server" {
  ami           = "ami-0e2c8ca47bde147c5" # Ubuntu 24.04 for us-east-1
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}