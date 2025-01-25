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
