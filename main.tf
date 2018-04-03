provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # owners = ["099720109477"] # Canonical
}

data "aws_vpc" "selected" {
  id = "${var.aws_vpc_id}"
}

resource "aws_security_group" "web-sg" {
  name        = "Web Server SG"
  description = "Allow inbound http traffic"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible-controlplane" {
  ami             = "${data.aws_ami.amazonlinux.id}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.web-sg.name}"]
  key_name        = "${var.key_name}"
  user_data       = "${base64encode(file("./provision.sh"))}"

  tags {
    Name = "web-server"
  }
}
