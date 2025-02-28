resource "local_file" "inventory" {
  content = <<EOF
[app_server]
ansible_host=${var.instance_public_ip} ansible_user=${var.ssh_user}
EOF
  filename = var.filename
}
