resource "aws_iam_role" "nodes" {
    name = "${var.env}-role-eks-nodes"

    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
    managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",   
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}
resource "aws_eks_node_group" "this" {
    for_each = var.node_groups

    cluster_name = aws_eks_cluster.this.name
    node_group_name = each.key
    node_role_arn = aws_iam_role.nodes.arn

    subnet_ids = [var.public_subnets[0]]

    capacity_type = each.value.capacity_type
    instance_types = each.value.instance_types

    scaling_config {
        desired_size = each.value.scaling_config.desired_size
        max_size = each.value.scaling_config.max_size
        min_size = each.value.scaling_config.min_size
    }
    update_config {
      max_unavailable =  1
    }

    labels = {
        role = each.key
    }

}