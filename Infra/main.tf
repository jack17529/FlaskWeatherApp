provider "aws" {
  region  = "us-east-1"
  version = "~> 3.17.0"
}

resource "aws_instance" "web1" {
  ami               = "ami-0885b1f6bd170450c"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "jack-HP"

  # need to open port 8080 for jenkins
  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt install git -y
                sudo apt install openjdk-11-jdk
                wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
                sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
                sudo apt update
                sudo apt install jenkins
                EOF  

  tags = {
    Name = "jenkins-master"
  }
}

resource "aws_instance" "web2" {
  ami               = "ami-0885b1f6bd170450c"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "jack-HP"

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
                sudo apt update
                sudo apt install docker-ce
                sudo systemctl start docker
                EOF

  tags = {
    Name = "staging"
  }
}

resource "aws_instance" "web3" {
  ami               = "ami-0885b1f6bd170450c"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "jack-HP"

  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
                sudo apt update
                sudo apt install docker-ce
                sudo systemctl start docker
                EOF

  tags = {
    Name = "production"
  }
}

#resource "aws_security_group" "web" {
#   name = "Web Security Group"
#  description = "Allow access to our web server"
#
#   ingress{
#      description = "Allow SSH"
#     from_port = 22
#    to_port = 22
#   protocol = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#}
#}
