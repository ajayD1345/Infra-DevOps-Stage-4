output "app_server_public_ip" {
  description = "Public IP of the app server"
  value       = module.Ec2-server.instance_public_ip
}
