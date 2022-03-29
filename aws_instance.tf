provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "myinstance" {
  ami                    = "ami-04893cdb768d0f9ee"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.keypair.id
  vpc_security_group_ids = [aws_security_group.allow_ports.id]


  tags = {
    Name = "myami"
  }
}
resource "aws_key_pair" "keypair" {
  key_name   = "jms_kdp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuSjkTE1c2SxyWMC8QrV7KUe8NggDZMtB1P5/a14XrDfUlrrrfMKu7vknaNR0qBXz1m3KeY8ilRVjx2vbR9S/0rYQAtWj5Us9WSFrFTGfREtqGhI9dhWApy5HiCIThzRLbxi9MRaVPjGYtSr/TQrULzknUskdWGzWTLbW4xDFoDAslxB4E7+kcU/I3hrdQvZLQ8QRYc3r7eFFOX6DYYPbz+lk8JfClhTmkBqw/m4vMmxIWLiQendCTaEIH9eLZfu2NwIK8zjnbb23bmFQkb8/uwdeOkEK7evemZfDnM8MrYxbkukkIdbl8ySLzSKDFpQNH2c3N29wraXv1n8szZmEmI5xGldFqHjrD0MylMEAEKDukvpcWaRM+hJ1C0t9y8nmUK5oZDUBAsVQKfqlm7Ptnw0moC0e7iMUxHmHbuzuVduyRF3S+Kq/WxgP0b8lFsopFHbG9P76IxTj67RSJPYlPmNSBPtvi6GdEgGTnQBWTKULdMsmSshoJrNxL+QwqakE= 91986@LAPTOP-5P2H8IGR"
}                                                                                                            # or-file("filename")
resource "aws_eip" "myeip" {
  instance = aws_instance.myinstance.id
  vpc      = true
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_security_group" "allow_ports" {
  name        = "allow_ports"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "httpd"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ports"
  }
}

                                                             #----------------------- user_data = <<EOF
  #!/bin/bash -xe
  sudo yum update
  sudo yum upgrade -y
  sudo hostnamectl set-hostname ec2-usersrv.citizix.com
  sudo yum install -y nginx vim
  sudo cat > /var/www/html/hello.html <<EOD
  Hello world!
  EOD
  EOF
------
  this have to be in a file-- user_data.sh
---------------------------
  #!/bin/bash
yum install httpd -y
echo "hey i am $(hostname -f)" > /var/www/html/index.html
service httpd start
chkconfig httpd on



-----------------------------------------------------------------------------------
  provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "myinstance" {
  ami                    = "ami-04893cdb768d0f9ee"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.keypair.id
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
    user_data = file("${path.module}/user_data.sh")
  
  
  tags = {
    Name = "myami"
  }
}
resource "aws_key_pair" "keypair" {
  key_name   = "jms_kdp"
  public_key = file("jms_kdp.pub")
}
resource "aws_eip" "myeip" {
  instance = aws_instance.myinstance.id
  vpc      = true
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_security_group" "allow_ports" {
  name        = "allow_ports"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "httpd"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ports"
  }
}

