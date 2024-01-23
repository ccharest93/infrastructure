terraform {
    // source = "git@github.com:ccharest93/infrastructure-modules.git//vpc?ref=vpc-v0.0.3"
    source = "git::ssh://git-codecommit.eu-west-2.amazonaws.com/v1/repos/infrastructure-modules//machine-learning//aws-datasources?ref=${local.source_version}"
}

include "root" {
    path = find_in_parent_folders()
}
inputs = {
    eks_version = "${local.eks_version}"
}

locals {
    environment_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    env = local.environment_vars.locals.env
    eks_version = local.environment_vars.locals.eks_version
    source_version="machine-learning/aws-datasources-v0.0.10"
}