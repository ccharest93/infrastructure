remote_state {
    backend = "s3"
    generate = {
        path = "state.tf"
        if_exists = "overwrite_terragrunt"
    }
    config = {
        profile = "maatra"
        role_arn = "arn:aws:iam::${local.aws_account_id}:role/terraform"
        bucket = "maatra-terraform-state"
        skip_bucket_root_access=true
        key = "${path_relative_to_include()}/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        dynamodb_table = "terraform-lock-table"
    }
}
#The reason we generate this provider here is because ALL the modules will need it, so it is better to generate it in root
generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region = "${local.aws_region}"
    profile = "maatra"
    assume_role {
        role_arn = "arn:aws:iam::${local.aws_account_id}:role/terraform"
    }
}
EOF
}

#so you pull HCL files from downstream of the module
locals {
    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    aws_account_id   = local.account_vars.locals.aws_account_id
    aws_region   = local.account_vars.locals.aws_region
}
inputs = merge(
    local.account_vars.locals
)
