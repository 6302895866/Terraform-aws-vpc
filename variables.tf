variable "aws_region" {
  default = "ap-south-1"
  description = "aws region to create resources "
 type = string
}

variable "cidr_block" {
  default = "10.0.0.0/16"
  type = string
  description = "value of the cidr block of the vpc"
}

variable "enable_dns_hostnames" {
  default = true
  type = bool
  description = "enable dns hostnames for the vpc"
}

variable "enable_dns_support" {
  type = bool
  default = true
  description = "enable dns support for vpc"
}

variable "public_subnet_cidr" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
  description = "value of the cidr block of the public subnet"
}
variable "create_public_subnet" {
  type = bool
  default = true
  description = "create public subnet or not"
  
  }

  variable "public_subnet_azs" {
    type = list(string)
   default = [ "ap-south-1a","ap-south-1b" ]
  }

  variable "create_private_subnet" {
    type = bool
    default = true
    description = "create private subnet or not"
  }

  variable "private_subnet_cidr" {
    type = list(string)
   default = [ "10.0.3.0/24", "10.0.4.0/24" ]
   description = "values of the cidr block of the private subnet"
  }

  variable "private_subnet_azs" {
    type = list(string)
    default = [ "ap-south-1a", "ap-south-1b" ]
    description = " values of the availability zones"
  }

  variable "create_nat_gateway" {
    type = bool
    default = true
    description = "create nat or not"
  }

  