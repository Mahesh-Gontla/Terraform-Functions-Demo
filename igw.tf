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
