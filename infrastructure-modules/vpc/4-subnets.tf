resource "aws_subnet" "public" {
    count = 2

    vpc_id = aws_vpc.this.id
    cidr_block = [for k, v in local.azs : cidrsubnet("10.11.0.0/16", 8, k + 48)][count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = true
    
    tags = { 
        Name = "${var.env}-public-${local.azs[count.index]}",
        "kubernetes.io/role/elb" = 1
    }
} 

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }

    tags = {
        Name = "${var.env}-public"
    }
}

resource "aws_route_table_association" "public" {
    count = 2
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}