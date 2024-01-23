terraform {
    // source = "git@github.com:ccharest93/infrastructure-modules.git//vpc?ref=vpc-v0.0.3"
    source = "git::ssh://git-codecommit.eu-west-2.amazonaws.com/v1/repos/infrastructure-modules//machine-learning//vpc?ref=${local.source_version}"
}

include "root" {
    path = find_in_parent_folders()
}
inputs = {
    env = "${local.env}"
}

locals {
    environment_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    env = local.environment_vars.locals.env
    source_version="machine-learning/vpc-v0.0.2"
}