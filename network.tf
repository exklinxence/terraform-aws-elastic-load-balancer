

resource "aws_vpc" "webapp-vpc" {
  cidr_block           = var.webapp-cird-block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = local.tags

}

resource "aws_internet_gateway" "webapp-igw" {
  vpc_id = aws_vpc.webapp-vpc.id
  tags   = local.tags
}

resource "aws_route_table" "webapp-rt" {
  vpc_id = aws_vpc.webapp-vpc.id

  route {
    cidr_block = var.ipv4_any_source
    gateway_id = aws_internet_gateway.webapp-igw.id
  }

  route {
    ipv6_cidr_block = var.ipv6_any_source
    gateway_id      = aws_internet_gateway.webapp-igw.id
  }

  tags = local.tags

}

resource "aws_subnet" "web-1a" {
  vpc_id            = aws_vpc.webapp-vpc.id
  cidr_block        = var.cidr_blocks[0]
  availability_zone = data.aws_availability_zones.az.names[0]
  tags              = local.tags
}

resource "aws_route_table_association" "webapp-rt-ass-1a" {
  subnet_id      = aws_subnet.web-1a.id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_subnet" "web-1b" {
  map_public_ip_on_launch = var.map_public_ip_on_launch
  vpc_id                  = aws_vpc.webapp-vpc.id
  cidr_block              = var.cidr_blocks[1]
  availability_zone       = data.aws_availability_zones.az.names[1]
}

resource "aws_route_table_association" "web-rt-ass-1b" {
  subnet_id      = aws_subnet.web-1b.id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_subnet" "app-1a" {
  map_public_ip_on_launch = var.map_public_ip_on_launch
  vpc_id                  = aws_vpc.webapp-vpc.id
  cidr_block              = var.cidr_blocks[2]
  availability_zone       = data.aws_availability_zones.az.names[0]
}

resource "aws_route_table_association" "app-rt-ass-1a" {
  subnet_id      = aws_subnet.app-1a.id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_subnet" "app-1b" {
  map_public_ip_on_launch = var.map_public_ip_on_launch
  vpc_id                  = aws_vpc.webapp-vpc.id
  cidr_block              = var.cidr_blocks[3]
  availability_zone       = data.aws_availability_zones.az.names[1]
}

resource "aws_route_table_association" "app-rt-ass-1b" {
  subnet_id      = aws_subnet.app-1b.id
  route_table_id = aws_route_table.webapp-rt.id
}

resource "aws_security_group" "web-sg" {
  vpc_id = aws_vpc.webapp-vpc.id
  ingress {
    protocol         = var.tcp_protocol_type
    from_port        = 80
    to_port          = 80
    cidr_blocks      = [var.ipv4_any_source]
    ipv6_cidr_blocks = [var.ipv6_any_source]

  }

  ingress {
    protocol         = var.tcp_protocol_type
    from_port        = 443
    to_port          = 443
    cidr_blocks      = [var.ipv4_any_source]
    ipv6_cidr_blocks = [var.ipv6_any_source]

  }

  ingress {
    protocol         = var.tcp_protocol_type
    from_port        = 81
    to_port          = 81
    cidr_blocks      = [var.webapp-cird-block]
    ipv6_cidr_blocks = [var.ipv6_any_source]

  }

  ingress {
    protocol         = var.tcp_protocol_type
    from_port        = 22
    to_port          = 22
    cidr_blocks      = ["${chomp(data.http.local-ip.body)}/32"]
    ipv6_cidr_blocks = [var.ipv6_any_source]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.ipv4_any_source]
    ipv6_cidr_blocks = [var.ipv6_any_source]
  }

  tags = local.tags
}

resource "aws_security_group" "app-sg" {
  vpc_id = aws_vpc.webapp-vpc.id

  ingress {
    protocol    = var.tcp_protocol_type
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = [var.cidr_blocks[0], var.cidr_blocks[1], var.cidr_blocks[2], var.cidr_blocks[3]]
  }

  ingress {
    protocol    = var.tcp_protocol_type
    from_port   = 8443
    to_port     = 8443
    cidr_blocks = [var.cidr_blocks[0], var.cidr_blocks[1], var.cidr_blocks[2], var.cidr_blocks[3]]
  }


  ingress {
    protocol    = var.tcp_protocol_type
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${chomp(data.http.local-ip.body)}/32"]
  }
}

resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.webapp-vpc.id
  ingress {
    protocol    = var.tcp_protocol_type
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = [var.cidr_blocks[2], var.cidr_blocks[3]]
  }

  ingress {
    protocol    = var.tcp_protocol_type
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${chomp(data.http.local-ip.body)}/32"]
  }
}