#VPC

resource "aws_vpc" "ecomm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames="true"

  tags = {
    Name = "ecomm-vpc"
  }
}

#PUBLIC SUBNET
resource "aws_subnet" "ecomm-public-sn" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name = "ecomm public subnet"
  }
}

#PRIVATE SUBNET
resource "aws_subnet" "ecomm-pvt-sn" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch="false"
  tags = {
    Name = "ecomm private subnet"
  }
}

#INTERNET GATEWAY
resource "aws_internet_gateway" "ecomm-igw" {
  vpc_id = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm igw"
  }
}

#PUBLIC ROUTE TABLE

resource "aws_route_table" "ecomm-pub-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm-igw.id
  }

  tags = {
    Name = "ecomm public rt"
  }
}

#PRIVATE ROUTE TABLE
resource "aws_route_table" "ecomm-pvt-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ecomm-nat.id
  }


  tags = {
    Name = "ecomm private rt"
  }
}

#SUBNET-ROUTE TABLE ASSOCIATION-PUBLIC
resource "aws_route_table_association" "ecomm-pub-asc" {
  subnet_id      = aws_subnet.ecomm-public-sn.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
}

#SUBNET ROUTE TABLE ASSOCIATION-PRIVATE
resource "aws_route_table_association" "ecomm-pvt-asc" {
  subnet_id      = aws_subnet.ecomm-pvt-sn.id
  route_table_id = aws_route_table.ecomm-pvt-rt.id
}

#AWS ELASTIC IP
resource "aws_eip" "ecomm-eip" {
  vpc      = true

 tags = {
    Name = "ecomm eip"
  }
}

#AWS NAT GATEWAY
resource "aws_nat_gateway" "ecomm-nat" {
  allocation_id = aws_eip.ecomm-eip.id
  subnet_id     = aws_subnet.ecomm-public-sn.id

  tags = {
    Name = "NAT GW"
  }

  depends_on = [aws_internet_gateway.ecomm-igw]
}

