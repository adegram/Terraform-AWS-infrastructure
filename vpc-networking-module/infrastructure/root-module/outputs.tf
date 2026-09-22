output "vpc_id" {
  description = "ID of the company VPC"
  value       = aws_vpc.company_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the company VPC"
  value       = aws_vpc.company_vpc.cidr_block
}

output "public_subnet_cidr_block" {
  description = "CIDR block of the public subnet"
  value       = aws_subnet.public_subnet.cidr_block
}

output "private_subnet_cidr_block" {
  description = "CIDR block of the private subnet"
  value       = aws_subnet.private_subnet.cidr_block
}

output "ami" {
  description = "The AMI to use for the instances"
  value       = var.ami
}

output "public_server_instance_type" {
  description = "The instance type for the public servers"
  value       = var.public_server_instance_type
}

output "private_server_instance_type" {
  description = "The instance type for the private servers"
  value       = var.private_server_instance_type
}

output "instance_tenancy" {
  description = "The tenancy of the instances"
  value       = var.instance_tenancy
}

output "trusted_cidr" {
  description = "The trusted CIDR block for security group rules"
  value       = var.trusted_cidr
}

output "public_instance_public_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = aws_instance.public_instance.public_ip
}
