provider "aws" {
  region = var.aws_region
}

module "security-groups" {
  source               = "./modules/security-groups"
  sg_name              = var.sg_name
  ssh_cidr_blocks      = var.ssh_cidr_blocks
  http_cidr_blocks     = var.http_cidr_blocks
  https_cidr_blocks    = var.https_cidr_blocks 
  outbound_cidr_blocks = var.outbound_cidr_blocks
  outbound_from_port   = var.outbound_from_port
  outbound_to_port     = var.outbound_to_port
  outbound_protocol    = var.outbound_protocol
  ssh_from_port        = var.ssh_from_port
  ssh_to_port          = var.ssh_to_port
  ssh_protocol         = var.ssh_protocol

  http_from_port       = var.http_from_port
  http_to_port         = var.http_to_port
  http_protocol        = var.http_protocol

  https_from_port      = var.https_from_port
  https_to_port        = var.https_to_port
  https_protocol       = var.https_protocol
}

module "Ec2-server" {
  source             = "./modules/Ec2-server"
  ami                = var.ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_ids = [module.security-groups.sg_id]
}

module "inventory" {
  source              = "./modules/inventory"
  instance_public_ip  = module.Ec2-server.instance_public_ip
  ssh_user            = var.ssh_user
  filename            = var.filename
}

resource "null_resource" "ansible_provision" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ${module.inventory.inventory_file} ../playbook.yml --private-key ~/Downloads/id2.rsa.pem"
  }
  depends_on = [module.Ec2-server, module.inventory]
}
