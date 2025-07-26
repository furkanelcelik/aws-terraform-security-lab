# SSH Security Group
resource "aws_security_group" "ssh" {
  name        = var.ssh_sg_name
  description = "Allow SSH and ICMP traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  ingress {
    description = "ICMP from allowed IPs"
    from_port   = -1 # -1 means all ICMP types
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_ip_range
  }

  tags = {
    Project = var.project_tag
  }
}

# Public HTTP Security Group
resource "aws_security_group" "public_http" {
  name        = var.public_http_sg_name
  description = "Allow HTTP and ICMP traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from allowed IPs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  ingress {
    description = "ICMP from allowed IPs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_ip_range
  }

  tags = {
    Project = var.project_tag
  }
}

# Private HTTP Security Group
resource "aws_security_group" "private_http" {
  name        = var.private_http_sg_name
  description = "Allow HTTP and ICMP traffic from the public SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP on 8080 from the public SG"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public_http.id]
  }

  ingress {
    description     = "ICMP from the public SG"
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.public_http.id]
  }

  tags = {
    Project = var.project_tag
  }
}

# Attach Security Groups to the Public Instance's Network Interface
resource "aws_network_interface_sg_attachment" "public_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_instance.public.network_interface_id
}

resource "aws_network_interface_sg_attachment" "public_http" {
  security_group_id    = aws_security_group.public_http.id
  network_interface_id = data.aws_instance.public.network_interface_id
}

# Attach Security Groups to the Private Instance's Network Interface
resource "aws_network_interface_sg_attachment" "private_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_instance.private.network_interface_id
}

resource "aws_network_interface_sg_attachment" "private_http" {
  security_group_id    = aws_security_group.private_http.id
  network_interface_id = data.aws_instance.private.network_interface_id
}

