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
