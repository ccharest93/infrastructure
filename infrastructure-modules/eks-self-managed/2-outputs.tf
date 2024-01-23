output "config"{
    value = "aws eks update-kubeconfig --name ${aws_eks_cluster.this.name} --role-arn arn:aws:iam::710948827076:role/terraform --region eu-west-2"
}