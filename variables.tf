# variables.tf
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}