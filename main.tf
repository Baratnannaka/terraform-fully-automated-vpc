provider "aws" {
    region = var.region
}

resource "aws_vpc" "tf-vpc" {
    cidr_block         = var.vpc_cidr
    instance_tenancy    = "default"

    tags = {
        Name = "tf-vpc"
        Location = "hyd"
    }
}


resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.tf-vpc.id
        tags = {
        Name = var.IGW_name
    }
}



resource "aws_subnet" "subnets" {
    count        = length(data.aws_availability_zones.azs.names)
    availability_zone = element(data.aws_availability_zones.azs.names,count.index)
    vpc_id       = aws_vpc.tf-vpc.id
    cidr_block   = element(var.subnet_cidr,count.index)

    tags = {
        Name = "Subnet-${count.index+1}"
    }
}






resource "aws_route_table" "terraform-public" {
    vpc_id = aws_vpc.tf-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
    }

    tags = {
        Name = var.Main_Routing_Table
    }
}

resource "aws_route_table_association" "terraform-public" {
    count          = length(data.aws_availability_zones.azs.names)
    subnet_id      = element(aws_subnet.subnets.*.id, count.index)
    route_table_id = aws_route_table.terraform-public.id
}

resource "aws_security_group" "allow_all" {
  name        = var.aws_security_group
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}


data "aws_subnet_ids" "example" {
  vpc_id = aws_vpc.tf-vpc.id
}

