variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "ami_id" {
  type        = string
  description = "Amazon Linux 2023 AMI for the chosen region."
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "min_size" {
  type    = number
  default = 2
}
variable "desired_capacity" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 4
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "trusted_cidr" {
  type        = string
  description = "Trusted client network allowed to reach the HTTPS listener."
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN in the same region as the ALB."
}
