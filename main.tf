resource "aws_vpc" "company_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Company-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.company_vpc.id
  cidr_block = var.public_subnet_cidr_block

  tags = {
    Name = "Public-company-subnet"
  }

}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.company_vpc.id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = "Private-company-subnet"
  }

}

resource "aws_internet_gateway" "company_igw" {
  vpc_id = aws_vpc.company_vpc.id

  tags = {
    Name = "company"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.company_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.company_igw.id
  }
}

resource "aws_route_table_association" "route_table" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "public_instance_sg" {
  name        = "HTTPS_access"
  description = "Allow HTTPS access"
  vpc_id      = aws_vpc.company_vpc.id

  tags = {
    Name = "Public_instance_SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_public" {
  security_group_id = aws_security_group.public_instance_sg.id
  cidr_ipv4         = var.trusted_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_security_group" "private_instance_sg" {
  name        = "HTTPS_access_to private server"
  description = "Allow HTTPS access from public instance ONLY"
  vpc_id      = aws_vpc.company_vpc.id

  tags = {
    Name = "Private_instance_SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_private" {
  security_group_id = aws_security_group.private_instance_sg.id
  referenced_security_group_id = aws_security_group.public_instance_sg.id

  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_instance" "public_instance" {
  ami               = var.ami
  instance_type     = var.public_server_instance_type
  subnet_id         = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]

  tags = {
    Name = "Company-public-server"
  }
}

resource "aws_instance" "private_instance" {
  ami               = var.ami
  instance_type     = var.private_server_instance_type
  subnet_id         = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  tags = {
    Name = "Company-private-server"
  }
}