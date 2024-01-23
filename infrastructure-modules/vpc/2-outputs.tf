output "vpc_id" {
    value = aws_vpc.this.id
}
output "subnet_ids" {
    value = aws_subnet.public[*].id
}
output "subnet_cidr_blocks" {
    value = aws_subnet.public[*].cidr_block
}
output "availability_zones" {
    value = aws_subnet.public[*].availability_zone
}