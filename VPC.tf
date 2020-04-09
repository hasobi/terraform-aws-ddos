//create VPC
resource "aws_vpc" "workshopvpc" {
  cidr_block           = "20.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "workshop-vpc"
  }
}

//create Internet Gateway
resource "aws_internet_gateway" "igwWorkshop" {
  vpc_id = aws_vpc.workshopvpc.id

  tags = {
    Name = "igwWorkshop"
  }
}

//create public Subnet
resource "aws_subnet" "workshopPublicSubnet" {
  vpc_id                  = aws_vpc.workshopvpc.id
  cidr_block              = "20.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "workshopPublicSubnet"
  }
}

//create public Subnet for RDS

//create Route Table with allocation to Internet Gateway
resource "aws_route_table" "routeTableWorkshop" {
  vpc_id = aws_vpc.workshopvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igwWorkshop.id
  }

  tags = {
    Name = "routeTableWorkshop"
  }
}

//create association RouteTable to Subnet
resource "aws_route_table_association" "aRouteTableSubnet" {
  subnet_id      = aws_subnet.workshopPublicSubnet.id
  route_table_id = aws_route_table.routeTableWorkshop.id
}


//create Security Group Web + SSH
resource "aws_security_group" "secGroupWorkshopWebSSH" {
  name        = "secGroupWorkshopWebSSH"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.workshopvpc.id

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secGroupWorkshopWebSSH"
  }
}
