resource "aws_iam_role" "eks" {
    name = "${var.env}role--eks-cluster"
    assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Effect": "Allow",
        }
    ]
    })
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    ]
}

resource "aws_eks_cluster" "this" {
    name = "${var.env}-eks-cluster"
    version = var.eks_version
    role_arn = aws_iam_role.eks.arn
    vpc_config {        
        endpoint_private_access = true
        endpoint_public_access = true
        subnet_ids = var.public_subnets
    }
    depends_on = [aws_iam_role_policy_attachment.eks]
}

