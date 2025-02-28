resource "aws_security_group" "instance" {
  name        = var.sg_name
  description = "Allow SSH, HTTP, and HTTPS inbound traffic"

  ingress {
    from_port   = var.ssh_from_port
    to_port     = var.ssh_to_port
    protocol    = var.ssh_protocol
    cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    from_port   = var.http_from_port
    to_port     = var.http_to_port
    protocol    = var.http_protocol
    cidr_blocks = var.http_cidr_blocks
  }

  ingress {
    from_port   = var.https_from_port
    to_port     = var.https_to_port
    protocol    = var.https_protocol
    cidr_blocks = var.https_cidr_blocks
  }

  egress {
    from_port   = var.outbound_from_port
    to_port     = var.outbound_to_port
    protocol    = var.outbound_protocol
    cidr_blocks = var.outbound_cidr_blocks
  }
}
