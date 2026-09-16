resource "aws_vpc" "terra_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "terra_vpc_pub_01" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.pub_sub_01
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sub-1"
  }
}

resource "aws_subnet" "terra_vpc_pub_02" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.pub_sub_02
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sub-2"
  }
}

resource "aws_subnet" "terra_vpc_priv_01" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.priv_sub_01
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "pri-sub-1"
  }
}

resource "aws_subnet" "terra_vpc_priv_02" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.priv_sub_02
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "pri-sub-2"
  }
}

resource "aws_subnet" "terra_vpc_data_01" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.data_sub_01
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "data-sub-1"
  }
}

resource "aws_subnet" "terra_vpc_data_02" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.data_sub_02
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "data-sub-2"
  }
}

resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "terra_igw"
  }
}

resource "aws_route_table" "terra_pub_rt" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "terra_pub_rt"
  }
}

resource "aws_route_table_association" "terr_pub_asso_a" {
  subnet_id      = aws_subnet.terra_vpc_pub_01.id
  route_table_id = aws_route_table.terra_pub_rt.id
}

resource "aws_route_table_association" "terr_pub_asso_b" {
  subnet_id      = aws_subnet.terra_vpc_pub_02.id
  route_table_id = aws_route_table.terra_pub_rt.id
}

resource "aws_route_table" "terra_pri_rt" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terra_natgw.id
  }

  tags = {
    Name = "terra_pri_rt"
  }
}

resource "aws_route_table_association" "terr_pri_asso_a" {
  subnet_id      = aws_subnet.terra_vpc_priv_01.id
  route_table_id = aws_route_table.terra_pri_rt.id
}

resource "aws_route_table_association" "terr_pri_asso_b" {
  subnet_id      = aws_subnet.terra_vpc_priv_02.id
  route_table_id = aws_route_table.terra_pri_rt.id
}




