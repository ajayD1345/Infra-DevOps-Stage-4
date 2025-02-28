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
}

module "Ec2-server" {
  source             = "./modules/Ec2-server"
  ami                = var.ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_ids = [module.security_group.sg_id]
}

module "inventory" {
  source              = "./modules/inventory"
  instance_public_ip  = module.app_server.instance_public_ip
  ssh_user            = var.ssh_user
  filename            = var.filename
}

resource "null_resource" "ansible_provision" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ${module.inventory.inventory_file} playbook.yml"
  }
  depends_on = [module.Ec2-server, module.inventory]
}
