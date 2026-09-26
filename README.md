# AWS Terraform Projects

A collection of AWS infrastructure projects built and managed using Terraform.

The projects in this repository focus on provisioning, configuring, and managing AWS infrastructure as code. Each project is organized separately and documents the Terraform configuration, infrastructure design, and deployment approach used.

## What You'll Find Here

The projects cover different areas of AWS infrastructure and Terraform, including:

- AWS networking and VPC infrastructure
- Subnets and route tables
- Internet and NAT gateways
- IAM and access management
- Compute resources, Databases and Storage
- DNS, Load balancing, Auto Scaling, Security groups and network access
- Monitoring and logging
- Multi-environment infrastructure
- Reusable Terraform modules, Remote Terraform state
- Infrastructure automation

## Technologies

- Terraform
- AWS
- HCL
- Git & GitHub
- AWS CLI

Additional AWS services and DevOps tools may be used where they are relevant to individual projects.

## Project Structure

Each AWS project I've kept in its own directory.

```text
aws-terraform-projects/
│
├── vpc-networking/
│   ├── bootstrap/
│   ├── vpc-networking-module/
│   ├── environments/
│   │   ├── dev-env-1/
│   │   └── prod-env-2/
│   ├── outputs.tf
│   ├── variables.tf
│   └── README.md
│
├── <next-aws-project>/
│   └── README.md
│
├── <another-aws-project>/
│   └── README.md
│
└── README.md
