terraform {
  required_providers {
    # Setting the AWS provider and version
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  # Setting the required Terraform version
  required_version = ">= 0.14.9"
}

variable "awsvars" {
  type = map(string)
  default = {
    subnet   = "subnet-xxxxxx"
    vpc      = "vpc-xxxxxx"
    publicip = false
  }
}

# Setting the AWS region we want to use
provider "aws" {
  profile = "aws-profile"
  region  = "ap-southeast-2"
}

resource "aws_instance" "test_server" {
  ami                         = "ami-xxxx"
  instance_type               = "t3.micro"
  subnet_id                   = lookup(var.awsvars, "subnet")
  associate_public_ip_address = lookup(var.awsvars, "publicip")

  tags = {
    Name       = "test"
    Deployment = "terraform"
  }
}

output "ec2instance" {
  value = aws_instance.test_server.arn
}