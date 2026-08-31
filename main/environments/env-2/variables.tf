variable "aws_region" {
  type = string
}

variable "public_subnet_cidr_block" {
  type = string
}

variable "private_subnet_cidr_block" {
  type = string
}

variable "instance_tenancy" {
  type = string
}

variable "vpc_cidr" {
  type = string
} 

variable "ami" {
  type = string
}

variable "private_server_instance_type" {
  type = string
}


variable "public_server_instance_type" {
  type = string
}

variable "trusted_cidr" {
  type = string
}