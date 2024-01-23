data "aws_availability_zones" "available" {
  state = "available"
    filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
}

resource "aws_vpc" "this" {
    cidr_block = "10.11.0.0/16"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.env}-vpc"
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

        tags = {
        Name = "${var.env}-igw"
    }
} 