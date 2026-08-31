# Scaling My AWS Infrastructure I Built

A Terraform project that provisions a secure, segmented AWS network (VPC, public/private subnets, security groups, and EC2 instances) for internal company access, built to scale across multiple environments with a self-provisioned, encrypted remote state backend.

## What This Project Does

- Provisions an isolated VPC with a public subnet (internet-facing) and a private subnet (internal only)
- Restricts HTTPS access into the public instance to a single trusted CIDR block, nothing else reaches it
- Locks the private instance down so it's reachable only from the public instance's security group, with no direct route to or from the internet
- Packages all of the above into a reusable Terraform module so multiple environments (branches/sites) can be deployed from the same codebase
- Provisions its own remote state backend (S3 bucket with versioning, encryption, and public access blocked) as code, rather than as a manual setup step

## Project Structure

```
.
├── bootstrap/                  # Provisions the S3 remote state backend
│   ├── main.tf                 # S3 bucket, versioning, encryption, public access block
│   ├── outputs.tf
│   └── provider.tf
│
└── main/
    ├── company-modules/         # Reusable network module
    │   ├── main.tf              # VPC, subnets, IGW, route table, security groups, instances
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── environments/
        ├── env-1/                # First environment/site
        │   ├── main.tf           # Calls company-modules, defines S3 backend
        │   ├── providers.tf
        │   ├── terraform.tfvars
        │   └── variables.tf
        │
        └── env-2/                # Second environment/site
            ├── main.tf
            ├── providers.tf
            ├── terraform.tfvars
            └── variables.tf
```

Each environment calls the same `company-modules` module and supplies its own variable values, so the network pattern is defined once and reused per site.

## Architecture Overview

- **VPC** split into a public subnet and a private subnet
- **Public subnet**: routed to an Internet Gateway, hosts the public-facing EC2 instance, only accepts inbound HTTPS (443) from a trusted CIDR block
- **Private subnet**: no route to the Internet Gateway at all, hosts the backend EC2 instance
- **Security groups**: the private instance's security group only accepts inbound HTTPS from the public instance's security group (via `referenced_security_group_id`), not from any IP range
- **Remote state**: each environment stores its Terraform state in a shared S3 bucket, isolated by a per-environment key, with state locking enabled (`use_lockfile = true`)
- **State backend security**: the S3 bucket is versioned (for recovery), encrypted at rest (AES256), and fully blocked from public access

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (project uses the `hashicorp/aws` provider, version `6.56.0`)
- An AWS account with credentials configured (e.g. via `aws configure` or environment variables)
- IAM permissions to create VPCs, subnets, security groups, EC2 instances, and S3 buckets

## Usage

### 1. Provision the remote state backend (one-time)

```bash
cd bootstrap
terraform init
terraform apply
```

This creates the S3 bucket that every environment's state will be stored in. It only needs to be run once, before any environment is deployed.

### 2. Deploy an environment

```bash
cd main/environments/env-1
terraform init
terraform plan
terraform apply
```

Repeat for `env-2` (or any additional environment folder) independently, each one has its own state file and lock, so environments won't interfere with each other.

### 3. Update variables per environment

Each environment's `terraform.tfvars` controls its own region, CIDR blocks, instance types, AMI, and trusted CIDR, edit that file to customize a given environment without touching the module.

## What's Next

- **VPC Peering** between environments, if two sites eventually need to talk to each other directly (Peering fits a two-VPC connection; Transit Gateway would only make sense once there are 3-5+ VPCs to interconnect)
- Remote backend for the `bootstrap` project itself, to remove its dependency on local state
- CI/CD pipeline to run `terraform plan` on PRs and `apply` on merge per environment
