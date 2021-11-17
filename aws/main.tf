locals {
  vpc_id           = "vpc-a0fb9bda"
  subnet_id        = "subnet-18ed0a55"
  ssh_user         = "ubuntu"
  key_name         = "ubuntu-key"
  private_key_path = "~/Downloads/ubuntu-key.pem"
}

provider "aws" {
  region = "us-east-1"
}

# This is used to define the required stuff should be from hashicorp and locks the version.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.21"
    }
  }
}

resource "aws_security_group" "jenkins" {

  name        = "jenkins_access"
  description = "Allow jenkins traffic"
  vpc_id      = local.vpc_id

  # for ssh
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for jenkins
  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # -1 means all protocols
  # all ip addresses are allowed according to cidr block.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "staging" {

  name        = "staging_access"
  description = "Allow Apache2 traffic"
  vpc_id      = local.vpc_id

  # for ssh
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for apache2
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # -1 means all protocols
  # all ip addresses are allowed according to cidr block.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "production" {

  name        = "production_access"
  description = "Allow Apache2 traffic"
  vpc_id      = local.vpc_id

  # for ssh
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for apach2
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # -1 means all protocols
  # all ip addresses are allowed according to cidr block.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "jenkins" {

  ami                         = "ami-083654bd07b5da81d"
  subnet_id                   = local.subnet_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.jenkins.id]
  key_name                    = local.key_name

  tags = {
    Name = "jenkins-master"
  }

  # remote-exec invokes a script on a remote resource after it is created.
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.jenkins.public_ip
    }
  }

  # local-exec invokes a local executable after a resource is created.
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.jenkins.public_ip}, --private-key ${local.private_key_path} jenkins.yaml"
  }

}

resource "aws_instance" "staging" {

  ami                         = "ami-083654bd07b5da81d"
  subnet_id                   = local.subnet_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.staging.id]
  key_name                    = local.key_name

  tags = {
    Name = "staging-server"
  }

  # remote-exec invokes a script on a remote resource after it is created.
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.staging.public_ip
    }
  }

  # local-exec invokes a local executable after a resource is created.
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.staging.public_ip}, --private-key ${local.private_key_path} server.yaml"
  }

}

resource "aws_instance" "production" {

  ami                         = "ami-083654bd07b5da81d"
  subnet_id                   = local.subnet_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.production.id]
  key_name                    = local.key_name

  tags = {
    Name = "production-server"
  }

  # remote-exec invokes a script on a remote resource after it is created.
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.production.public_ip
    }
  }

  # local-exec invokes a local executable after a resource is created.
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.production.public_ip}, --private-key ${local.private_key_path} server.yaml"
  }

}


# will just return the public IP for jenkins server.
output "jenkins_ip" {
  value = aws_instance.jenkins.public_ip
}

# will just return the public IP for staging server.
output "staging_ip" {
  value = aws_instance.staging.public_ip
}

# will just return the public IP for production server.
output "production_ip" {
  value = aws_instance.production.public_ip
}
