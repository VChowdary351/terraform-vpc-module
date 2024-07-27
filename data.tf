data "aws_availability_zones" "available" {
  state = "available"
}

# default vpc id info
data "aws_vpc" "default" {
  default = true
} 