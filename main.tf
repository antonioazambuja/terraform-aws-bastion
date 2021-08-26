resource "aws_security_group" "bastion" {
  name   = "bastion-security-group"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.security_group_tags, { Name=var.bastion_name })
}

resource "aws_security_group_rule" "bastion_cidr_block_rules" {
  for_each          = { for rule in var.security_group_rules: rule.description => rule if rule.source_security_group_id == "" || !rule.self && length(rule.cidr_blocks) > 0 }
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

resource "aws_security_group_rule" "bastion_source_security_group_id_rules" {
  for_each                 = { for rule in var.security_group_rules: rule => rule if length(rule.cidr_blocks) == 0 || !rule.self && rule.source_security_group_id != "" }
  security_group_id        = aws_security_group.bastion.id
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  type                     = each.value.type
}

resource "aws_security_group_rule" "bastion_self_rules" {
  for_each          = { for rule in var.security_group_rules: rule => rule if length(rule.cidr_blocks) == 0 || rule.source_security_group_id == "" && rule.self }
  security_group_id = aws_security_group.bastion.id
  self              = each.value.self
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
}

data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.bastion.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ aws_security_group.bastion.id ]
  key_name               = var.key_pair_name
  ebs_optimized          = var.ebs_optimized

  tags = merge(var.bastion_tags, { Name=var.bastion_name })
}