# AWS Networking Variables
variable "aws_region" {}
variable "vpc_cidr" {}
variable "name_prefix" {}
variable "public_subnets_count" {}
variable "private_subnets_count" {}

variable "autocreate_public_cidr_block" {}
variable "autocreate_private_cidr_block" {}
variable "manual_public_cidr_block" {}
variable "manual_private_cidr_block" {}


# EKS Cluster Variables
variable "eks_version" {}
variable "cluster_name" {}

variable "public_acccess_cidrs" {}
#variable "cluster_subnet_ids" {}

variable "service_ipv4_cidr" {}

# EKS Nodegroup Variables
variable "nodegroup_keyname" {}
variable "node_group_name" {}
#variable "nodegroup_subnet_ids" {}

variable "nodegroup_ami_type" {}
variable "nodegroup_instance_types" {}
variable "nodegroup_capacity_type" {}
variable "nodegroup_disk_size" {}

variable "ec2_ssh_key" {}

variable "nodegroup_desired_size" {}
variable "nodegroup_min_size" {}
variable "nodegroup_max_size" {}

variable "max_unavailable_percentage" {}

variable "create_ebs_controller" {}
variable "create_lbc_controller" {}
variable "create_cloudwatch_controller" {}
