terraform {
    // source = "git@github.com:ccharest93/infrastructure-modules.git//vpc?ref=vpc-v0.0.3"
    source = "git::ssh://git-codecommit.eu-west-2.amazonaws.com/v1/repos/infrastructure-modules//machine-learning//eks-managed-wrapper?ref=${local.source_version}"
}
include "root" {
    path = find_in_parent_folders()
}
inputs = {
    env = "${local.env}"
    eks_version = local.eks_version
    public_subnets = "${dependency.vpc.outputs.subnet_ids}"
    vpc_id = "${dependency.vpc.outputs.vpc_id}"
    node_groups = {
        general2 = {
            capacity_type = "SPOT"
            instance_types = ["t3.large"]
            subnet_ids = [dependency.vpc.outputs.subnet_ids[0]]
            desired_size = 2
            max_size = 2
            min_size = 2
            enable_bootstrap_user_data = true
            ami_id       = dependency.gpu-ami.outputs.node-ami
            block_device_mappings = {
                xvda = {
                device_name = "/dev/xvda"
                    ebs = {
                        volume_size           = 65
                        volume_type           = "gp3"
                        iops                  = 3000
                        encrypted             = false
                        delete_on_termination = true
                    }
                }
            }
        }
        # gpunodes = {
        #     instance_types = ["g4dn.xlarge"]
        #     #instance_types = ["t2.xlarge"]
        #     #capacity_type  = "ON_DEMAND"
        #     capacity_type = "SPOT"
        #     max_size = 2
        #     min_size = 1
        #     desired_size = 1
        #     subnet_ids = [dependency.vpc.outputs.subnet_ids[0]]
        #     ami_id       = dependency.gpu-ami.outputs.gpu-ami
        #     enable_bootstrap_user_data = true
        #     block_device_mappings = {
        #         xvda = {
        #             device_name = "/dev/xvda"
        #             ebs = {
        #                 volume_size           = 200
        #                 volume_type           = "gp3"
        #                 iops                  = 3000
        #                 encrypted             = false
        #                 delete_on_termination = true
        #             }
        #         }
        #     }
        # }
    }
}

locals {
    environment_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    env = local.environment_vars.locals.env
    eks_version = local.environment_vars.locals.eks_version
    source_version="machine-learning/eks-managed-wrapper-v0.0.19"
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
dependency "gpu-ami" {
    config_path = "../../1-lifecycle/aws-datasources"

    mock_outputs = {
        gpu-ami = "ami-0"
        node-ami = "ami-1"
    }
}