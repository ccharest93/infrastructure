data "aws_ami" "eks_gpu_node" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-gpu-node-1.28-*"]
  }
}

module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = ">= 19.12"
  cluster_name                   = "${var.env}-ekscluster"
  cluster_version                = var.eks_version
  cluster_endpoint_public_access = true
  cluster_enabled_log_types      = ["api", "authenticator", "audit", "scheduler", "controllerManager"]

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets

  eks_managed_node_group_defaults = {
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
      AmazonEFSCSIDriverPolicy    = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy",
      S3Policies = aws_iam_policy.default_node.arn,
    }
  }
  cluster_addons = {
    aws-efs-csi-driver = { most_recent = true }
    aws-ebs-csi-driver = { most_recent = true }
    aws-mountpoint-s3-csi-driver = { most_recent = true }
    coredns = { most_recent = true}
    kube-proxy = { most_recent = true }
    vpc-cni = { most_recent = true }
  }
  eks_managed_node_groups = var.node_groups

}


resource "aws_iam_policy" "default_node" {
  name_prefix = "${var.env}-iam-default"
  description = "Default policy for cluster "
  policy      = data.aws_iam_policy_document.default_node.json
}

data "aws_iam_policy_document" "default_node" {
  statement {
    sid    = "S3"
    effect = "Allow"

    actions = [
      "s3:*",
      "kms:*",
    ]

    resources = ["*"]
  }
}