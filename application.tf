# Provider configuration
provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "/home/rob/.aws/credentials"
  profile                 = "kfsoladmin"
}

data "aws_ami" "app-ami" {
  most_recent = true
#root_device_type - The type of root device (ie: ebs or instance-store).
#filter {
#   name   = "root_device_type"
#   values = ["ebs"]
 #}
 #root_device_type = ["ebs"]
  #  owners      = ["self"]
  # ubuntu ami account ID
owners = ["099720109477"]
#  filter {
#  name   = "virtualization-type"
#  values = ["hvm"]
#}
#let's use the path like visible in aws ami-launch:
#ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180912 - ami-0bdf93799014acdc4
#Canonical, Ubuntu, 18.04 LTS, amd64 bionic image build on 2018-09-12
#Root device type: ebs Virtualization type: hvm
filter {
  name   = "name"
  #values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#  values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  values = ["ubuntu/images/hvm-ssd/ubuntu-*"]

}

#  filter {
#    name   = "owner-alias"
#    values = ["amazon"]
#  }
}
# Resource configuration
resource "aws_instance" "master-instance" {
  ami                    = "${data.aws_ami.app-ami.id}"
  instance_type          = "t2.micro"

  tags {
    Name = "master-instance"
    Env  = "test"
  }
}

output "hostname" {
  value = "${aws_instance.master-instance.private_dns}"
}
output "ami" {
  value = "${data.aws_ami.app-ami.id}"
}
