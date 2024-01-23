terraform {
    // source = "git@github.com:ccharest93/infrastructure-modules.git//vpc?ref=vpc-v0.0.3"
    source = "git::ssh://git-codecommit.eu-west-2.amazonaws.com/v1/repos/infrastructure-modules//machine-learning//k8s-addons?ref=${local.source_version}"
}
include "root" {
    path = find_in_parent_folders()
}
inputs = {
    eks_name = dependency.eks.outputs.eks_name
    efs_model_input_id = dependency.efs_input.outputs.efs_id
    efs_model_output_id = dependency.efs_output.outputs.efs_id
}
locals {
    environment_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    source_version="machine-learning/k8s-addons-v0.0.7"
}
dependency "efs_input" {
    config_path = "../../1-lifecycle/efs"

    mock_outputs = {
        efs_id = "fs-123456"
    }
}
dependency "efs_output" {
    config_path = "../../2-lifecycle/efs"

    mock_outputs = {
        efs_id = "fs-123456"
    }
}
dependency "eks" {
    config_path = "../../2-lifecycle/eks-managed-wrapper"

    mock_outputs = {
        eks_name = "eks-123456"
    }
}
generate "kubectl_provider" {
    path = "kubectl-provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
data "aws_eks_cluster" "eks" {
    name = var.eks_name
}

data "aws_eks_cluster_auth" "eks" {
    name = var.eks_name
}

provider "kubectl" {
    host = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.eks.token
}
EOF
}
