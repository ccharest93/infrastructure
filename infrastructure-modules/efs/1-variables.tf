variable "env" {
    description = "Environment name."
    type = string
} 
variable "vpc_id" {
    description = "VPC ID."
    type = string
}
variable "subnet_id" {
    description = "Subnet ID."
    type = string
}
variable "availability_zone" {
    description = "Availability Zone."
    type = string
}
variable "subnet_cidr_block" {
    description = "Subnet CIDR block."
    type = string
}
