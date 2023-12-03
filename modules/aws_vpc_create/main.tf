data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "aws_vpc_my" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_${var.my_name}",
  }
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.aws_vpc_my.id
  tags = {
    Name = "igw_${var.my_name}"
  }
}

resource "aws_subnet" "aws_subnet_my" {
  count                   = "${length(var.subnet_cidr)}"
  vpc_id                  = aws_vpc.aws_vpc_my.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.subnet_cidr[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_0${count.index+1}_${var.my_name}"
  }
}

resource "aws_route_table" "aws_route_table_my" {
  vpc_id = aws_vpc.aws_vpc_my.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
  }
  tags = {
    Name = "route_table_${var.my_name}"
  }
}

resource "aws_route_table_association" "associate_subnet_route_table_my" {
  count          = "${length(aws_subnet.aws_subnet_my)}"
  subnet_id      = aws_subnet.aws_subnet_my[count.index].id
  route_table_id = aws_route_table.aws_route_table_my.id
}

resource "aws_ecr_repository" "ecr_for_my_deploy" {
  name = "my_image"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
  tags = {
    Name = "route_table_${var.my_name}"
  }
}

resource "aws_ebs_volume" "volume_for_prometheus" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 4
  tags = {
    Name = "volume_${var.my_name}"
  }
}