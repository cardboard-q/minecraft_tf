resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a" # CHANGE BASED ON YOUR REGION
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "arta"{
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "main" {
  name   = "main"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 25565 # port for minecraft
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["XXX"] # SET ALLOWED IP ADDRESS FOR SSH
  }
  # needed for terraform even though it is default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_spot_instance_request.ec2.spot_instance_id
  allocation_id = aws_eip.eip.id
}

resource "aws_eip" "eip" {
  vpc      = true
}
