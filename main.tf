
resource "aws_vpc" "new_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_hostnames
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.new_vpc.id
  count = var.create_public_subnet ? length(var.public_subnet_cidr) : 0
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = true

}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.new_vpc.id
  count = var.create_private_subnet ? length(var.private_subnet_cidr) : 0
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.private_subnet_azs[count.index]
  map_public_ip_on_launch = false

}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.new_vpc.id
  count = var.create_public_subnet ? 1 : 0
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.new_vpc.id
  count = var.create_public_subnet ? 1 : 0

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id 
}

resource "aws_eip" "nat" {
    domain = vpc 
  count = var.create_nat_gateway ? 1 : 0
  depends_on = [ aws_internet_gateway.public_igw ]
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id    = aws_subnet.public.id
  count = var.create_nat_gateway ? 1: 0
  depends_on = [ aws_internet_gateway.public_igw ]
}


resource "aws_route_table" "private" {
    vpc_id = aws_vpc.new_vpc.id
    count = var.create_private_subnet? 1 :0
    route = {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id 
    }
  
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id 
    count = var.create_private_subnet ? length(var.private_subnet_cidr) : 0
  
}