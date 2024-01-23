output "config"{
    value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --role-arn arn:aws:iam::710948827076:role/terraform --region eu-west-2"
} 
output "eks_name"{
    value = "${module.eks.cluster_name}"
}