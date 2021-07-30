terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.50"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

variable "cidr_blocks" {
    description = "cidr_blocks with name tags and cidr_block for vpc and subnets"
    type = list(object({
        cidr_block = string
        name = string
    }))
}

variable avail_zone {
    default = "us-east-2b"
}

resource "aws_vpc" "dev-vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
        Name = var.cidr_blocks[0].name
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    tags = {
        Name = var.cidr_blocks[1].name
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    availability_zone = var.avail_zone
    tags = {
        Name = "dev-subnet-2"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.dev-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-2.id
}