terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
#      version = "~> 3.40.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}
resource "aws_instance" "app_server" {
  ami           = "ami-0e2e44c03b85f58b3"
  instance_type = "t2.micro"
  subnet_id     = "subnet-d8454d91"
  key_name               = "glaws"
  vpc_security_group_ids = ["sg-0c367b269bbe63146"]
 tags = {
   Name        = "TestProvisionFromTerraform"
   Project     = "Infra"
   Environment = "test"
 }
}
