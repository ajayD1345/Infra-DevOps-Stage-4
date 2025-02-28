output "inventory_file" {
  description = "Path to the generated inventory file"
  value       = local_file.inventory.filename
}
