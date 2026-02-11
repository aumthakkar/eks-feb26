
locals {
  public_cidr  = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_cidr = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}

locals {
  public_cidr_block  = var.autocreate_public_cidr_block ? local.public_cidr : var.manual_public_cidr_block
  private_cidr_block = var.autocreate_private_cidr_block ? local.private_cidr : var.manual_private_cidr_block
}

locals {
  cluster_subnet_ids   = aws_subnet.my_private_subnets[*].id
  nodegroup_subnet_ids = aws_subnet.my_private_subnets[*].id
}

locals {
  security_groups = {
    my_public_security_group = {
      name        = "${var.name_prefix}-public-security-group"
      description = "SSH Public Security Group "
      tags = {
        Name = "${var.name_prefix}-public-security-group"
      }
      ingress = {
        ssh = {
          from       = 22
          to         = 22
          cidr_block = ["0.0.0.0/0"]
          protocol   = "tcp"
        }
      }
    }
  }
}