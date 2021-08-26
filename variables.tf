variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "bastion_name" {
  description = "Name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name"
  type        = string
}

variable "ebs_optimized" {
  description = "EBS Optimized"
  type        = bool
}

variable "security_group_tags" {
  description = "A map of tags to assign to the AWS Security Group."
  type        = map
  default     = {}
  validation {
    condition     = length(var.security_group_tags) > 0
    error_message = "Tags from AWS Security Group is empty."
  }
}

variable "bastion_tags" {
  description = "A map of tags to assign to the bastion."
  type        = map
  default     = {}
  validation {
    condition     = length(var.bastion_tags) > 0
    error_message = "Tags from bastion is empty."
  }
}

variable "security_group_rules" {
  description = "Rules of Security Group"
  type = list(object({
    cidr_blocks = list(string)
    description = string
    from_port = number
    to_port = number
    protocol = string
    source_security_group_id = string
    self = bool
    type = string
  }))
  default = [{
    cidr_blocks       = ["0.0.0.0/0"]
    description       = "Allow communicate to any IP."
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    source_security_group_id = ""
    self = false
    type              = "ingress"
  }]
}