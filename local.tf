locals {
  azs = slice(data.aws_availability_zones.available.names,0,2)
}

# locals {
#   default = data.aws_vpc.default.id
# }

