resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allow SSH access"

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

resource "aws_key_pair" "main" {
  key_name   = "terraform-managed-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.main.key_name

  security_groups = [aws_security_group.ssh_access.name]

  tags = {
    Name = "terraform-managed-instance"
  }
}