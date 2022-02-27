
# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

locals {
  web_instance_type_map = {
   stage = "t2.micro"
   prod = "t2.large"
  }
  web_instance_count_map = {
   stage = 1
   prod = 2
  }
  envs = {
    stage = {
     "t2.micro" = data.aws_ami.ubuntu.id
    }
    prod = {
     "t3.micro" = data.aws_ami.ubuntu.id
     "t3.large" = data.aws_ami.ubuntu.id
    }
  }

}



resource "aws_instance" "web" {
  count         = local.web_instance_count_map[terraform.workspace]
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  availability_zone = "eu-central-1a"

  lifecycle {
     create_before_destroy = true
  }
}

resource "aws_instance" "cache" {
  for_each = local.envs[terraform.workspace]

  ami           = each.key
  instance_type = each.value
  availability_zone = "eu-central-1a"

}

