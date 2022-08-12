resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg"
  description = "LoadBalancer security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Ingress from VPC CIDR"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "app-alb"

  load_balancer_type = "application"

  vpc_id             = var.vpc_id
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]

  target_groups = [
    {
      name_prefix      = "app-"
      backend_protocol = "HTTP"
      backend_port     = 5000
      target_type      = "instance"
    }
  ]

 http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
]

  tags = {
    Environment = "dev"
  }
}
