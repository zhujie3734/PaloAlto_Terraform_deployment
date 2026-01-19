provider "aws" {
  region = "eu-north-1"
}

# ------------------------------------------------
# 1. VPC
# ------------------------------------------------
resource "aws_vpc" "lab" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "lab-vpc"
  }
}

# ------------------------------------------------
# 2. Subnet
# ------------------------------------------------
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "eu-north-1a"

  # no public IPs
  map_public_ip_on_launch = false

  tags = {
    Name = "lab-private-subnet"
  }
}

# ------------------------------------------------
# 3. Security Group (for ICMP tests)
# ------------------------------------------------
resource "aws_security_group" "lab_sg" {
  vpc_id = aws_vpc.lab.id

  ingress {
    description = "Allow ICMP from anywhere (for testing)"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab-ec2-sg"
  }
}

# ------------------------------------------------
# 4. IAM role for SSM (no public IP needed)
# ------------------------------------------------
resource "aws_iam_role" "ssm_role" {
  name = "LabEC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  role = aws_iam_role.ssm_role.name
}

# ------------------------------------------------
# 5. EC2 Instance (private-only)
# ------------------------------------------------
#data "aws_ssm_parameter" "amzn2" {
#  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-ebs"
#}

resource "aws_instance" "lab_ec2" {
  ami                    = "ami-0c7d68785ec07306c"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.lab_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "lab-private-ec2"
  }
}

