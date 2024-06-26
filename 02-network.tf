resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "maina" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "eu-central-1a"
  cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "mainb" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "eu-central-1b"
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.maina.id
  route_table_id = aws_route_table.main.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.mainb.id
  route_table_id = aws_route_table.main.id
}

