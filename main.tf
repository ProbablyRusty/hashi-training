#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-2df66d3b
#
# Your subnet ID is:
#
#     subnet-75a08610
#
# Your security group ID is:
#
#     sg-4cc10432
#
# Your Identity is:
#
#     testing-skunk
#

terraform {
  backend atlas {
    name = "rustyross/training"
  }
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "web_count" {
  default = "3"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "${var.web_count}"
  instance_type          = "t2.micro"
  ami                    = "ami-2df66d3b"
  vpc_security_group_ids = ["sg-4cc10432"]
  subnet_id              = "subnet-75a08610"

  tags {
    Identity             = "testing-skunk"
    rustyross.purpose    = "testing"
    rustyross.created_by = "terraform"
    Name                 = "web ${count.index + 1} of ${var.web_count}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
