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
