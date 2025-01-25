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
