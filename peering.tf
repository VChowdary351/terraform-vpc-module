# default vpc peering connections with main vpc(roboshop)

resource "aws_vpc_peering_connection" "peering" {
  #count = var.is_peering_required ? 1 : 0
  #peer_owner_id = var.peer_owner_id   # aws a/c id of the owner
  peer_vpc_id   = aws_vpc.main.id

  # requestor, default vpc
  vpc_id        = var.requestor_vpc_id
  auto_accept   = true

  tags =merge(
    {
        Name = "VPC Peering between default and ${var.project_name}"
    },
    var.common_tags
  ) 
}

resource "aws_route" "default_route" {
  #count = var.is_peering_required ? 1 : 0
  route_table_id            = var.default_route_table_id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
# add route roboshop public route table
resource "aws_route" "public_peering" {
  #count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# add route roboshop private route table
resource "aws_route" "private_peering" {
  #count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# add route roboshop database route table
resource "aws_route" "database_peering" {
  #count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}