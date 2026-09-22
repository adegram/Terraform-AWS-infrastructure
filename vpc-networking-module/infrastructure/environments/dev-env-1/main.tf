module "root-module" {
  source = "../../root-module" 

  aws_region                 = var.aws_region
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidr_block   = var.public_subnet_cidr_block
  private_subnet_cidr_block  = var.private_subnet_cidr_block
  instance_tenancy           = var.instance_tenancy
  ami                        = var.ami
  private_server_instance_type = var.private_server_instance_type
  public_server_instance_type  = var.public_server_instance_type
  trusted_cidr               = var.trusted_cidr
}

terraform {
  backend "s3" {
    bucket = "company-vpc-tf-state-bucket"
    key    = "company-vpc-env-1/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}
output "vpc_id" {
  description = "The ID of the VPC"
  value = module.root-module.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value = module.root-module.vpc_cidr
}

output "public_subnet_cidr_block" {
  description = "The CIDR block of the public subnet"
  value = module.root-module.public_subnet_cidr_block
}

output "private_subnet_cidr_block" {
  description = "The CIDR block of the private subnet"
  value = module.root-module.private_subnet_cidr_block
}

output "instance_tenancy" {
  description = "The tenancy of the instances"
  value = module.root-module.instance_tenancy
}

output "ami" {
  description = "The AMI to use for the instances"
  value = module.root-module.ami
}

output "public_server_instance_type" {
  description = "The instance type for the public servers"
  value = module.root-module.public_server_instance_type
}

output "private_server_instance_type" {
  description = "The instance type for the private servers"
  value = module.root-module.private_server_instance_type
}

output "trusted_cidr" {
  description = "The trusted CIDR block for security group rules"
  value = module.root-module.trusted_cidr
}

output "public_instance_public_ip" {
  description = "Public IP address of the public EC2 instance"
  value = module.root-module.public_instance_public_ip
}