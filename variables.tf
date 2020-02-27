variable "region" {
    default = "us-east-1"
}

variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "subnet_cidr" {
    type    = "list"
    default = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24","10.10.4.0/24","10.10.5.0/24","10.10.6.0/24"]
}

#variable "azs" {
#    type = "list"
#    default = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1"]
#}


# Declare the data source
data "aws_availability_zones" "azs" {}
