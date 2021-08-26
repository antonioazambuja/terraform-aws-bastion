# AWS EC2/Bastion Terraform module

Terraform module which create EC2/Bastion resources on AWS.

## Usage
```hcl
module "bastion" {
  source = "github.com/antonioazambuja/terraform-aws-bastion"
  vpc_id = module.vpc.vpc_id
  bastion_name = "my-test"
  subnet_id = "subnet-id"
  instance_type = "t3.micro"
  key_pair_name = "test"
  ebs_optimized = true
  security_group_rules = [
    {
      cidr_blocks = ["0.0.0.0/0"],
      description = "Global access"
      from_port = 0
      to_port = 0
      protocol = "-1"
      type = "ingress"
      self = false
      source_security_group_id = ""
    }
  ]
  security_group_tags = {
    Name = "my-test"
    Project = "TEST"
  }
  bastion_tags = {
    Name = "my-test"
    Project = "TEST"
  }
}
```