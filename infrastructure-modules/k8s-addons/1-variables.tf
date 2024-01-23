#used by terragrunt generate provider
variable "eks_name" {
    description = "EKS cluster name."
    type = string
}
variable "efs_model_input_id" {
    description = "EFS ID."
    type = string
}
variable "efs_model_output_id" {
    description = "EFS ID."
    type = string
}