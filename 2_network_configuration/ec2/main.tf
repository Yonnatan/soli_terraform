# EC2 instance in VPC
resource "aws_instance" "ec2_vpc" {
  ami                    = "ami-0694d931cee176e7d" # Amazon Linux 2 AMI ID for eu-west-1
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.sg_vpc.id]
  key_name               = var.key-pair


  tags = {
    Name = var.name_prefix
  }
}

# Security group for EC2 
resource "aws_security_group" "sg_vpc" {
  name        = "${var.name_prefix}-sg"
  description = "Security group for EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}