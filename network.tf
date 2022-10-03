resource "aws_vpc" "vpc-terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.vpc-terraform.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    "Name" = "public-subnet-a"
  }
}
resource "aws_subnet" "public_subnet_b" {
  vpc_id = aws_vpc.vpc-terraform.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  tags = {
    "Name" = "public-subnet-b"
  }
}
resource "aws_subnet" "private_subnet_c" {
  vpc_id     = aws_vpc.vpc-terraform.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.region}a"
  tags={
    "Name" = "private-subnet-c"
  }
}
resource "aws_subnet" "private_subnet_d" {
  vpc_id = aws_vpc.vpc-terraform.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.region}b"
  tags = {
    "Name" = "private-subnet-d"
  }
}
resource "aws_eip" "nat" {
  vpc=true
  depends_on = [ ]
}
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.vpc-terraform.id
}
resource "aws_nat_gateway" "nat-gw" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.private_subnet_c.id
    depends_on = [
      aws_internet_gateway.internet-gw
    ]
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc-terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
}
resource "aws_route_table_association" "association" {
  subnet_id = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.rt.id
}