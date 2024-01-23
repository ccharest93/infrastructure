variable "env" {
    description = "Environment name."
    type = string
} 
variable "eks_version" {
    description = "EKS version."
    type = string
    default = "1.28"
}
variable "public_subnets" {
    description = "Public subnets."
    type = list(string)
}
variable "vpc_id" {
    description = "VPC ID."
    type = string
}

variable "node_groups" {
    description = "EKS node groups"
    type = map(any)
}