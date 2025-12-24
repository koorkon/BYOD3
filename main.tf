# main.tf

provider "aws" {
  region = var.aws_region  
}

resource "aws_instance" "splunk_server" 
  ami           = "ami-012967cc5a8c9f891" 
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id

  tags = {
    Name = var.instance_name
  }
}