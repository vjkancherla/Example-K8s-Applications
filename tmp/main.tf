provider "aws" {
  region = "us-east-1" # Change to your desired AWS region
}

data "aws_subnet" "existing_subnets" {
  ids = ["subnet-12345678", "subnet-87654321"] # Replace with the IDs of your existing subnets
}

resource "aws_subnet" "tagged_subnets" {
  count = length(data.aws_subnet.existing_subnets.ids)

  id = data.aws_subnet.existing_subnets.ids[count.index]

  tags = {
    Name        = "Tagged Subnet ${count.index + 1}"
    Environment = "Production" # Customize as needed
  }
}

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

