variable "cidr_block" {
  
}
variable "enable_dns_hostnames" {
    default = true
  
}
variable "enable_dns_support" {
    default = true
  
}
variable "common_tags" {
    default = {}
  
}
variable "project_name" {
    default = {

    }
}
variable "igw_tags" {
    default = {}
  
}
variable "public_subnet_cidr" {
    type = list
   validation {
    condition     = length(var.public_subnet_cidr) == 2
    error_message = "Please provide 2 public subnet cidr's"
  } 
}

variable "private_subnet_cidr" {
    type = list
   validation {
    condition     = length(var.private_subnet_cidr) == 2
    error_message = "Please provide 2 private subnet cidr's"
  } 
}

variable "database_subnet_cidr" {
    type = list
   validation {
    condition     = length(var.database_subnet_cidr) == 2
    error_message = "Please provide 2 private subnet cidr's"
  } 
}

variable "nat_gw_tags" {
    default = {}
  
}
variable "aws_db_subnet_group_tags" {
    default = {}
  
}

variable "is_peering_required" {
    default = false
  
}

variable "requestor_vpc_id" {
  
}

variable "default_route_table_id" {
  
}

variable "default_vpc_cidr" {
  
}