resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-vpc-${var.environment}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "${var.app_name}-subnet-a-${var.environment}"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "${var.app_name}-subnet-c-${var.environment}"
  }
}

resource "aws_subnet" "public_a_api_server" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "${var.app_name}-public-subnet-for-api-server-a-${var.environment}"
  }
}

resource "aws_subnet" "public_c_api_server" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "${var.app_name}-public-subnet-for-api-server-c-${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_a_web" {
  subnet_id      = aws_subnet.public_a_api_server.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_c_web" {
  subnet_id      = aws_subnet.public_c_api_server.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "${var.app_name}-private-subnet-a-${var.environment}"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "${var.app_name}-private-subnet-c-${var.environment}"
  }
}
