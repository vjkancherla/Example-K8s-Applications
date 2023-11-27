provider "aws" {
  region = "us-west-2" # Replace with your desired AWS region
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21" # Replace with your desired EKS version
  subnets         = var.private_subnets
  vpc_id          = var.vpc_id
  create_oidc_provider = true

  cluster_additional_security_group_ids = [aws_security_group.eks_cluster_sg.id]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  name_prefix = "eks-cluster-"
  vpc_id      = var.vpc_id

  // Define your inbound rules here
  // Example rule allowing SSH from specified CIDR blocks:
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  // Add other inbound rules as needed
}

module "eks_fargate_profile_kube_system" {
  source             = "terraform-aws-modules/eks/aws//modules/fargate"
  cluster_name       = module.eks.cluster_id
  fargate_namespace  = "kube-system"
  pod_execution_role_arn = module.eks.fargate_pod_execution_role_arn
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "eks_fargate_profile_karpenter" {
  source             = "terraform-aws-modules/eks/aws//modules/fargate"
  cluster_name       = module.eks.cluster_id
  fargate_namespace  = "karpenter"
  pod_execution_role_arn = module.eks.fargate_pod_execution_role_arn
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed."
}

variable "private_subnets" {
  description = "List of private subnets where EKS nodes will be placed."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks to allow inbound connections to the EKS cluster security group."
  type        = list(string)
  default     = []
}
