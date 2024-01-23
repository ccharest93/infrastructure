resource "aws_eks_addon" "aws-efs-csi-driver" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "aws-efs-csi-driver"
}
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
}
resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
}
resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
}