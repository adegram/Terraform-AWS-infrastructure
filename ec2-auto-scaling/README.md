# Ec2 Auto Scaling

## Overview

An EC2 Auto Scaling application pattern with an HTTPS Application Load Balancer and private target security-group relationship.

## Objective and design

The module consumes pre-existing VPC/subnets, AMI, certificate and trusted CIDR; it creates ALB, launch template, target group and ASG. Review the example bootstrap before production use.

## Architecture and flow

The module consumes pre-existing VPC/subnets, AMI, certificate and trusted CIDR; it creates ALB, launch template, target group and ASG. Review the example bootstrap before production use.

## Technologies

Terraform and AWS provider registry access; existing VPC/subnets, Amazon Linux AMI and ACM certificate; AWS credentials only for plan/apply

## Project structure

- `main.tf`
- `outputs.tf`
- `variables.tf`

## Prerequisites

Terraform and AWS provider registry access; existing VPC/subnets, Amazon Linux AMI and ACM certificate; AWS credentials only for plan/apply

## Setup and configuration

Use the commands below from this project directory unless a path is stated. Keep local credentials and generated state outside version control. Review every example value and replace reserved example domains, CIDRs, account IDs, repository owners, and image names before connecting a real environment.

Provide existing VPC/subnets, current regional AMI, ACM certificate, and trusted CIDR through variables. Review costs and plan before any apply.

## Format, initialize and validate

```bash
terraform fmt -check -recursive 
terraform init
terraform validate
terraform plan -var="vpc_id=..." -var="public_subnet_ids=[...]" -var="ami_id=..." -var="trusted_cidr=..." -var="certificate_arn=..."
```

A `terraform plan` may require AWS credentials and valid input IDs, but it does not create resources. Do not run `terraform apply` or `terraform destroy` without reviewing the plan and explicitly authorizing that cloud operation. Existing Terraform examples in sibling projects are maintained separately.

## Security and operations

- No secrets belong in Git. Use environment-specific secret stores and the cloud/CI credential mechanisms described above.
- Review IAM, network exposure, branch protection, and resource ownership before using a real account or cluster.
- Preserve logs and build artifacts only as long as operationally necessary.


## Future improvements

Add project-specific integration tests, pinned image digests and dependency updates, automated policy checks, and operational dashboards/alerts once a real deployment target is configured. Avoid enabling external publish/deploy stages until repository variables, protected environments, IAM trust, branch rules and rollback ownership are in place

## Terraform state

Terraform uses local state by default. Keep state files private; they can contain sensitive values. Before team or production use, configure an encrypted, versioned remote backend with locking and restricted access.

## Security and operations

- No credentials, private keys, tokens, or passwords are stored in this project. Use your platform's secret store or workload identity.
- Review cloud resource costs, IAM permissions, network exposure, and the generated plan before provisioning infrastructure.
- Use least-privilege credentials and a disposable non-production environment for demonstrations.
- Cloud deployment, infrastructure apply, and Git push are not performed by these implementation files automatically.
