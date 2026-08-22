# AWS Networking (Terraform)

Terraform setup for a small company network on AWS — one VPC, a public subnet with an HTTPS-facing server, and a private subnet with a backend server that isn't reachable from the internet at all.

## What this builds

- A VPC (`10.0.0.0/16` by default)
- A public subnet and a private subnet
- An Internet Gateway + route table for the public subnet only (the private subnet has no route out)
- A public EC2 instance that serves HTTPS, reachable only from a defined trusted IP — not the open internet
- A private EC2 instance reachable only over HTTPS, and only from the public instance's security group
- No SSH anywhere — no key pair, no open port 22, no bastion host

Nothing fancy — no load balancer, no autoscaling, no NAT gateway. It's the core pattern: public in front, private behind, and the private box can't talk to the internet or be talked to from it except through the public instance.

## Files

```
main.tf              all the resources — VPC, subnets, routing, security groups, instances
providers.tf          AWS provider + version pin
variables.tf          input variable declarations, no defaults
terraform.tfvars      the actual values for this environment
```

`terraform.tfvars` is where you change things per environment/region. Nothing in `main.tf` should ever need editing just to redeploy somewhere else.

## Requirements

- Terraform >= 1.x
- AWS provider `~> 6.56.0`
- AWS credentials configured (env vars, `~/.aws/credentials`, whatever you normally use)
- An AMI ID valid for the region you're deploying to — the one in `terraform.tfvars` is region-specific, swap it if you change `aws_region`

## Variables

| Variable | What it's for |
|---|---|
| `aws_region` | Region to deploy into |
| `vpc_cidr` | CIDR block for the VPC |
| `public_subnet_cidr_block` | CIDR for the public subnet |
| `private_subnet_cidr_block` | CIDR for the private subnet |
| `instance_tenancy` | VPC tenancy, usually `default` |
| `ami` | AMI ID for both instances |
| `public_server_instance_type` | Instance size for the public-facing server |
| `private_server_instance_type` | Instance size for the private/backend server |
| `trusted_cidr` | The one external source allowed to reach the public instance over HTTPS — your office's public IP as a `/32`, not a range |

Public and private instance types are separate on purpose — the front-facing box and the backend don't need to be sized the same.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Tear it down with `terraform destroy` when you're done, obviously.

## A couple of things worth knowing before you touch this

- `trusted_cidr` needs to be a `/32` — a single IP, not a range. Run `curl ifconfig.me` from your office network to get the real value; don't guess or leave a placeholder in there, and don't reuse `public_subnet_cidr_block` for this — that's the subnet's internal range, not an external source, and mixing the two up will either break the subnet or let the wrong traffic through.
- There is no SSH access to either instance. If something needs installing or reconfiguring on the private server, there's currently no way in — that's intentional, not an oversight, but it does mean day-two operations aren't solved yet (see below).
- The private instance's HTTPS rule references the public instance's security group instead of an IP range, so it keeps working even if the public instance's IP changes or the instance itself is replaced.
- There's no NAT gateway here, so the private instance has zero internet access — inbound or outbound.
- State is local (`terraform.tfstate`) right now. Fine for one person poking at this, not fine for a team — move to an S3 + DynamoDB backend before anyone else touches it.

## Not in here yet

- **Admin access to the private server** — most likely via SSM Session Manager once it's needed, rather than reopening SSH. Requires VPC interface endpoints for `ssm`, `ssmmessages`, and `ec2messages` (since the private subnet has no internet route), plus an IAM role/instance profile on the instance.
- Remote state backend
- Multi-AZ subnets (everything's in one AZ right now)
- Outputs for the public instance's IP (check `terraform show` or the console for now)
- A process for keeping `trusted_cidr` current if the office IP isn't static