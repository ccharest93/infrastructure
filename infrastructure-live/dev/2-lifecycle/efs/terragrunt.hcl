terraform {
    // source = "git@github.com:ccharest93/infrastructure-modules.git//vpc?ref=vpc-v0.0.3"
    source = "git::ssh://git-codecommit.eu-west-2.amazonaws.com/v1/repos/infrastructure-modules//machine-learning//efs?ref=${local.source_version}"
}

include "root" {
    path = find_in_parent_folders()
}

locals {
    environment_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    env = local.environment_vars.locals.env

    source_version="machine-learning/efs-v0.0.2"
}

inputs = {
    env = "${local.env}2"

    availability_zone = dependency.vpc.outputs.availability_zones[0]
    subnet_id = dependency.vpc.outputs.subnet_ids[0]
    subnet_cidr_block = dependency.vpc.outputs.subnet_cidr_blocks[0]
    vpc_id = dependency.vpc.outputs.vpc_id
}
dependency "vpc" {
    config_path = "../../1-lifecycle/vpc"

    mock_outputs = {
        availability_zones = ["us-east-1a","us-east-1b"]
        subnet_ids = ["subnet-0","subnet-1"]
        vpc_id = "vpc-0"
        subnet_cidr_blocks = ["10.0.0.0/0","10.0.0.0/0"]
    }
}