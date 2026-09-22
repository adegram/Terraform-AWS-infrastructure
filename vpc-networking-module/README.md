# AWS Infrastructure with Terraform

A reusable Terraform project for provisioning a secure, segmented AWS infrastructure across multiple environments. The project implements a VPC with public and private subnets, controlled security-group access, EC2 instances, and a secure S3-based remote state backend.

The infrastructure is designed around **reusability, environment isolation, security, and infrastructure as code (IaC)**.

## Architecture

The project provisions the following AWS resources:

* VPC
* Public and private subnets
* Internet Gateway
* Route tables and subnet associations
* Security groups
* EC2 instances
* S3 remote Terraform state backend
* S3 versioning and server-side encryption
* S3 public access blocking
* Environment-specific Terraform state and locking

### Network Flow

The public EC2 instance accepts HTTPS traffic only from a defined trusted CIDR block. The private EC2 instance does not accept traffic directly from the internet and only permits HTTPS traffic originating from the public instance's security group.

## Key Features

### Secure Network Segmentation

The VPC is divided into public and private subnets:

* **Public subnet** — connected to the Internet Gateway and hosts the externally accessible EC2 instance.
* **Private subnet** — isolated from direct internet access and hosts the internal EC2 instance.

### Security Group-Based Access

Security groups enforce controlled communication between the instances.

The public instance allows inbound HTTPS traffic only from the configured trusted CIDR.

The private instance allows inbound HTTPS traffic only from the public instance's security group rather than from an IP range.

This creates an explicit security-group-to-security-group trust relationship.

### Reusable Terraform Module

The infrastructure is organized around a reusable `root-module`.

Each environment calls the same module while supplying its own configuration through variables.

This allows the same infrastructure pattern to be deployed across multiple environments without duplicating the underlying Terraform configuration.

### Remote State Management

Terraform state is stored remotely in Amazon S3.

The backend includes:

* S3 versioning for state recovery
* Server-side encryption
* Public access blocking
* Environment-specific state keys
* Terraform state locking using `use_lockfile = true`

### Environment Isolation

Each environment has its own Terraform configuration and state.

For example:

```text
dev-env-1
prod-env-2
```

Additional environments can be created by adding another environment directory and referencing the reusable module.

---

## Project Structure

```text
vpc-networking-module/
│
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   └── provider.tf
│
└── infrastructure/
    │
    ├── root-module/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    └── environments/
        │
        ├── dev-env-1/
        │   ├── main.tf
        │   ├── providers.tf
        │   ├── terraform.tfvars
        │   └── variables.tf
        │
        └── prod-env-2/
            ├── main.tf
            ├── providers.tf
            ├── terraform.tfvars
            └── variables.tf
```

### Directory Responsibilities

| Directory      | Purpose                                                          |
| -------------- | ---------------------------------------------------------------- |
| `bootstrap/`   | Creates the S3 bucket used for Terraform remote state            |
| `root-module/` | Reusable Terraform module containing the core AWS infrastructure |
| `dev-env-1/`   | Development environment configuration                            |
| `prod-env-2/`  | Production environment configuration                             |

Each environment calls the same `root-module` and provides environment-specific values through variables.

---

## Technologies Used

* **AWS**
* **Terraform**
* **Amazon VPC**
* **Amazon EC2**
* **Amazon S3**
* **Security Groups**
* **Linux**

### Terraform Provider

This project uses the:

```text
hashicorp/aws
```

provider, version:

```text
6.56.0
```

---

## Deployment

### 1. Bootstrap the Remote State Backend

The bootstrap configuration creates the S3 bucket used by the environments to store Terraform state.

```bash
cd bootstrap

terraform init
terraform plan
terraform apply
```

This step only needs to be performed once.

> **Note:** The bootstrap configuration itself uses local Terraform state. A future improvement is to move the bootstrap state to a separate remote backend.

---

### 2. Deploy the Development Environment

```bash
cd infrastructure/environments/dev-env-1

terraform init
terraform plan
terraform apply
```

Terraform will initialize the S3 backend and provision the environment using the reusable module.

---

### 3. Deploy the Production Environment

```bash
cd infrastructure/environments/prod-env-2

terraform init
terraform plan
terraform apply
```

Each environment maintains its own state, allowing environments to be managed independently.

---

## Environment Configuration

Environment-specific values are defined in `terraform.tfvars`.

Typical configuration includes:

```hcl
region       = "..."
vpc_cidr     = "..."
public_cidr  = "..."
private_cidr = "..."
instance_type = "..."
ami_id       = "..."
trusted_cidr = "..."
```

This allows environments to use different:

* AWS regions
* VPC CIDR ranges
* Subnet CIDRs
* EC2 instance types
* AMIs
* Trusted source networks

without modifying the reusable module.

---

## Terraform Workflow

The recommended workflow for making infrastructure changes is:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

Before destroying an environment, review the resources carefully:

```bash
terraform plan -destroy
```

Then, if destruction is intentional:

```bash
terraform destroy
```

---

## Security Considerations

This project implements several security controls:

* Public and private network segmentation
* Restricted inbound HTTPS access
* Security-group-to-security-group communication
* No direct internet access to the private instance
* S3 public access blocking
* S3 server-side encryption
* S3 versioning for Terraform state recovery
* Environment-specific state isolation

### Important

The `terraform.tfvars` files should not contain sensitive credentials or secrets.

AWS credentials should be managed through AWS CLI configuration, environment variables, IAM roles, or another appropriate credential-management mechanism.

If `terraform.tfvars` contains environment-specific sensitive values, ensure it is excluded from version control.

---

## Future Improvements

### CI/CD Integration

Introduce a CI/CD pipeline to automatically:

1. Run `terraform fmt`
2. Run `terraform validate`
3. Generate `terraform plan` on pull requests
4. Apply approved changes after merge

---

## What This Project Demonstrates

This project demonstrates practical experience with:

* Designing AWS VPC networking
* Public/private subnet architecture
* AWS security groups
* EC2 provisioning
* Terraform modules
* Terraform variables and outputs
* Multi-environment infrastructure
* Remote Terraform state
* S3 security controls
* Infrastructure as Code
* Reusable infrastructure design

The primary goal is to demonstrate how AWS infrastructure can be **designed once, parameterized, and consistently deployed across multiple environments using Terraform**.
