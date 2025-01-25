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
