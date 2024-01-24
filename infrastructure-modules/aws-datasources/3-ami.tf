data "aws_ssm_parameter" "gpu-ami" {
    name   = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2-gpu/recommended/image_id"
}
data "aws_ssm_parameter" "node-ami" {
    name   = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2/recommended/image_id"
}