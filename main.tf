provider "aws" {
  region = var.aws_region
}

# Data source to get information about the existing public instance, including its network interface
data "aws_instance" "public" {
  instance_id = var.public_instance_id
}

# Data source to get information about the existing private instance, including its network interface
data "aws_instance" "private" {
  instance_id = var.private_instance_id
}
