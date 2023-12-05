provider "aws" {
  region = "us-east-1" # Change to your desired AWS region
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Change to your desired availability zone

  # Tags for subnet1
  tags = {
    Name = "Subnet 1"
    Environment = "Development"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Change to your desired availability zone

  # Tags for subnet2
  tags = {
    Name = "Subnet 2"
    Environment = "Production"
  }
}

# Add more subnets as needed and specify tags for each one
provider "aws" {
  region = "us-east-1" # Change to your desired AWS region
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Change to your desired availability zone

  # Tags for subnet1
  tags = {
    Name = "Subnet 1"
    Environment = "Development"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Change to your desired availability zone

  # Tags for subnet2
  tags = {
    Name = "Subnet 2"
    Environment = "Production"
  }
}

# Add more subnets as needed and specify tags for each one


variable "var_a" {
  default = [{ a = "b" }, { b = "c" }, { c = "d" }]
}

variable "var_b" {
  default = [{ c = "d" }]
}

# Convert var_a and var_b to sets
locals {
  set_a = toset(var.var_a)
  set_b = toset(var.var_b)
}

# Calculate the difference between set_a and set_b
locals {
  var_c = setdifference(local.set_a, local.set_b)
}

output "var_c" {
  value = local.var_c
}


variable "var_a" {
  default = [{a = "b"}, {b = "c"}, {c = "d"}]
}

variable "var_b" {
  default = [{c = "d"}]
}

variable "var_c" {
  default = [for item in var_a : item if !contains(var(var_b), item)]
}

