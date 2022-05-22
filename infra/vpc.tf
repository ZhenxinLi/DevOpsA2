// • Create a VPC with CIDR block 10.0.0.0/16. 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "RMIT Assignment 2"
  }
}

/* • Create 9 subnets with size /22 with 3 layers (named public, private, and data) across 3 
availability zones (az1=us-east-1a, az2=us-east-1b, az3=us-east-1c). Name the subnets 
consecutively as public_az1, public_az2, ..., data_az2, data_az3. Only the public subnets 
should be configured to map_public_ip_on_launch=true. */
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/22"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public AZ1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/22"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public AZ2"
  }
}

resource "aws_subnet" "public_az3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.8.0/22"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public AZ3"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/22"
  availability_zone = "us-east-1a"
  //  map_public_ip_on_launch = False

  tags = {
    Name = "private AZ1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/22"
  availability_zone = "us-east-1b"
  // map_public_ip_on_launch = False

  tags = {
    Name = "private AZ2"
  }
}

resource "aws_subnet" "private_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.24.0/22"
  availability_zone = "us-east-1c"
  // map_public_ip_on_launch = False

  tags = {
    Name = "private AZ3"
  }
}

resource "aws_subnet" "data_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/22"
  availability_zone = "us-east-1a"
  //  map_public_ip_on_launch = False

  tags = {
    Name = "data AZ1"
  }
}

resource "aws_subnet" "data_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.36.0/22"
  availability_zone = "us-east-1b"
  //  map_public_ip_on_launch = False

  tags = {
    Name = "data AZ2"
  }
}

resource "aws_subnet" "data_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.40.0/22"
  availability_zone = "us-east-1c"
  //  map_public_ip_on_launch = False

  tags = {
    Name = "data AZ3"
  }
}

// • Add an internet gateway to the VPC. 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "RMIT Assignment 2 igw"
  }
}

// • Add a default route table to the VPC which routes 0.0.0.0/0 to the internet gateway.  
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RMIT Assignment 2 route table"
  }
}