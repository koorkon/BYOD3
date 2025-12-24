variable "aws_region" {
  type        = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_name" {
  type = string
}
variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}