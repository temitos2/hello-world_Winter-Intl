data "template_file" "userdata" {
  template = file("${path.module}/userdata.tpl")
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg"
  description = "Application security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Ingress from VPC CIDR"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "app-server" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = var.private_subnets[0]
  key_name               = var.key_name
  user_data              = data.template_file.userdata.rendered

  tags = {
    Name = "Application-Server"
  }
}
