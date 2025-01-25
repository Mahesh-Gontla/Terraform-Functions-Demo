provider "aws" {
  region = var.aws_region
}

locals {
  Owner      = "Dev-Team"
  CostCenter = "AWS-Dev-Team"
  TeamDL     = "chinnagontla123@gmail.com"
}

#variable.tf 

variable "aws_region" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "key_name" {}
variable "azs" {}
variable "public_cidr_block" {}
variable "private_cidr_block" {}
variable "environment" {}
variable "ingress_value" {}

#terraform.tfvars

aws_region         = "ap-south-1"
vpc_cidr           = "172.18.0.0/16"
vpc_name           = "MyVPC-TF-Functions-Demo"
key_name           = "DevOps-TerraformPractice"
azs                = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_cidr_block  = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24", "172.18.4.0/24", "172.18.5.0/24", "172.18.6.0/24"]
private_cidr_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24", "172.18.40.0/24", "172.18.50.0/24", "172.18.60.0/24"]
environment        = "Dev"
ingress_value      = ["80", "22", "443", "8080", "3306", "1900"]

resource "aws_vpc" "MyVPC-Using-TF-Functions" {
  cidr_block           = var.vpc_cidr #var.vpc_cidr-->it will also will work
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.vpc_name}" #var.vpc_name 
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}" #var.environment
  }
}

resource "aws_subnet" "MyPublic-Subnets" {
  count             = length(var.public_cidr_block)
  vpc_id            = aws_vpc.MyVPC-Using-TF-Functions.id
  cidr_block        = var.public_cidr_block[count.index]
  availability_zone = element(var.azs, count.index % length(var.azs)) # Handles cases where azs is shorter

  tags = {
    Name        = "${var.vpc_name}-MyPublic-Subnets-${count.index + 1}"
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}

resource "aws_subnet" "MyPrivate-Subnets" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.MyVPC-Using-TF-Functions.id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = element(var.azs, count.index % length(var.azs)) # Handles cases where azs is shorter

  tags = {
    Name        = "${var.vpc_name}-MyPrivate-Subnets-${count.index + 1}"
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}

resource "aws_internet_gateway" "MyIGW-TF" {
  vpc_id = aws_vpc.MyVPC-Using-TF-Functions.id #aws_vpc.MyVPC-Using-TF-Functions.id

  tags = {
    Name        = "${var.vpc_name}-IGW"
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}" #var.environment
  }
}

resource "aws_route_table" "Public-RT-TF" {
  vpc_id = aws_vpc.MyVPC-Using-TF-Functions.id #aws_vpc.MyVPC-Using-TF-Functions.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW-TF.id
  }

  tags = {
    Name        = "${var.vpc_name}-Public-RT-TF"
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}

resource "aws_route_table" "Private-RT-TF" {
  vpc_id = aws_vpc.MyVPC-Using-TF-Functions.id #aws_vpc.MyVPC-Using-TF-Functions.id

  tags = {
    Name        = "${var.vpc_name}-Private-RT-TF"
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}

resource "aws_route_table_association" "MyRT-ASST-PubSubnets" {
  #count = 3
  count          = length(var.public_cidr_block)
  subnet_id      = element(aws_subnet.MyPublic-Subnets.*.id, count.index)
  route_table_id = aws_route_table.Public-RT-TF.id
}

resource "aws_route_table_association" "MyRT-ASST-PvtSubnets" {
  #count = 3
  count          = length(var.private_cidr_block)
  subnet_id      = element(aws_subnet.MyPrivate-Subnets.*.id, count.index)
  route_table_id = aws_route_table.Private-RT-TF.id
}
#for rt association-->syntax called splat syntax
#google-->terraform splat expression

resource "aws_security_group" "MySG-TF-Allow_All" {
  name        = "${var.vpc_name}-allow-all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.MyVPC-Using-TF-Functions.id

  dynamic "ingress" {
    for_each = var.ingress_value
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-MySG-TF-Allow_All"
    Owner       = local.Owner
    CostCenter  = local.CostCenter
    TeamDL      = local.TeamDL
    environment = var.environment

  }
}
