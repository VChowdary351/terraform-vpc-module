resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support

  tags = merge(
    var.common_tags,
    {
        Name = var.project_name
    }
  )
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.igw_tags
    )
  
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = true

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-public-${local.azs[count.index]}"
        }
    )
  
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-private-${local.azs[count.index]}"
        }
    )
  
}

resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-database-${local.azs[count.index]}"
        }
    )
  
}

resource "aws_eip" "eip" {
    domain = "vpc"
  
}
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    {
        Name = var.project_name
    },
    var.nat_gw_tags

  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.main.id
  # }
  tags =merge(
    var.common_tags,
    {
        Name = "${var.project_name}-public"
    }
  ) 
}

resource "aws_route" "public" {
      route_table_id = aws_route_table.public.id
      destination_cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.main.id
  # }

  tags =merge(
    var.common_tags,
    {
        Name = "${var.project_name}-private"
    }
  ) 
}

resource "aws_route" "private" {
      route_table_id = aws_route_table.private.id
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.main.id
  # }

  tags =merge(
    var.common_tags,
    {
        Name = "${var.project_name}-database"
    }
  ) 
}

resource "aws_route" "database" {
      route_table_id = aws_route_table.database.id
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}



