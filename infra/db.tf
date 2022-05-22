resource "aws_security_group" "db_sg" {
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
    description = "appropriate database port"
    from_port   = 27017
    to_port     = 27017
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

/* • an EC2 instance named “db” deployed in the data_az1 (use the latest Amazon Linux 2 
64-bit (x86) image and deploy a t2.micro instance size). */
/* • The “db” instance should allow ingress on the appropriate database port and allow 
SSH ingress on port 22 */
resource "aws_instance" "db" {
  # ami = data.aws_ami.ubuntu.id
  ami             = data.aws_ami.Linux.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.data_az1.id
  security_groups = [aws_security_group.db_sg.id]
  associate_public_ip_address = true
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = "Assignment 2 db"
  }
}

