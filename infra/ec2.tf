resource "aws_key_pair" "deployer" {
  key_name   = "rmit-assignment-2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFy3KGcK8l96Dkdt0FIJ3UCgnthZoJJA7qmxtGWkRqUMQl6GWL4GC6+viA7MBpXwFG3Yp94W5iKniDtitugMJ5tBIk7BoP9jqyD1F+F0HFSViB2RMAstLQxl3XWa0Tzpwy7F2TKvzafxG0Ejt6T6e66xSTn/5v0fCnCOatzjZOuotnXEAIHb3s080gzOCSo1d3kXfBO11EyljlP99VaC7fO8SrQlId1PSCnUSnH73WhLjZVmd5dlG2jWl7E1Z2begTE84x/96GLxOyNSgK4uHZYuRPWDzSVJLDx8FtHvzOYD2DiST/uH0gK03mF15IG/u6I9ofAasGxBpaUmPbCzaSL+LWLQS+clRe/7sB4k8w8HtYiFSVXbU4np4YznHcV/+lbkYxbenc01wPI3RnB1PtAw0uqZtHaoYyyio3oCkuPmqnzNHtX+AVE++nhgUQmZ5m8ol6bdG/qy9S0/b7YiXjGU9mQnae81KTxKFTtYpC+9CvGI+yzY/PmKWuqIV6Abc= jk@LAPTOP-0JLP6FRS"
}

resource "aws_security_group" "web_sg" {
  description = "Allow SSH and http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
    # security_groups = aws_instance.db.security_groups
    # to be modified by individuals
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

/* • a public load balancer deployed in the public layer (all AZs), with a listener and target 
group. Note: we are not using an auto scaling configuration in this assignment.  */
resource "aws_lb_target_group" "AT2-tg" {
  name     = "AT2-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb" "AT2-lb" {
  name               = "AT2-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "web_front_end" {
  load_balancer_arn = aws_lb.AT2-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.AT2-tg.arn
  }
}

/* • an EC2 instance named “web” deployed into private_az1 (use the latest Amazon Linux 
2 64-bit (x86) image and deploy a t2.micro instance size). */
/* • The “web” instance should allow ingress on the appropriate application port and SSH 
ingress on port 22 */
resource "aws_instance" "web" {
  ami             = data.aws_ami.Linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]
  subnet_id       = aws_subnet.private_az1.id
  associate_public_ip_address = true
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = "Assignment 2 web"
  }
}

data "aws_ami" "Linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
