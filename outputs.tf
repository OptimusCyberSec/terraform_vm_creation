# Output Values for Terraform Configuration
# These outputs provide important information after deployment

# Resource Group Information
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Network Information
output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "virtual_network_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.internal.name
}

output "subnet_address_prefix" {
  description = "Address prefix of the subnet"
  value       = azurerm_subnet.internal.address_prefixes
}

# Virtual Machine Information
output "virtual_machine_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "virtual_machine_size" {
  description = "Size/SKU of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.size
}

output "admin_username" {
  description = "Administrator username for the virtual machine"
  value       = azurerm_linux_virtual_machine.main.admin_username
}

# Network Access Information
output "public_ip_address" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip_address" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.main.private_ip_address
}

# SSH Connection Information
output "ssh_connection_command" {
  description = "SSH command to connect to the virtual machine"
  value       = "ssh ${azurerm_linux_virtual_machine.main.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "ssh_private_key" {
  description = "Private SSH key for connecting to the virtual machine"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true  # This ensures the private key is not displayed in logs
}

# Storage Information
output "os_disk_name" {
  description = "Name of the OS disk"
  value       = azurerm_linux_virtual_machine.main.os_disk[0].name
}

output "data_disk_name" {
  description = "Name of the data disk"
  value       = azurerm_managed_disk.data.name
}

output "data_disk_size" {
  description = "Size of the data disk in GB"
  value       = azurerm_managed_disk.data.disk_size_gb
}

# Security Information
output "network_security_group_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.main.name
}

# Useful Azure Portal Links
output "azure_portal_vm_url" {
  description = "Direct link to the VM in Azure Portal"
  value       = "https://portal.azure.com/#@/resource/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.Compute/virtualMachines/${azurerm_linux_virtual_machine.main.name}/overview"
}

output "azure_portal_resource_group_url" {
  description = "Direct link to the resource group in Azure Portal"
  value       = "https://portal.azure.com/#@/resource/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.main.name}/overview"
}

# Cost Information
output "estimated_monthly_cost_note" {
  description = "Note about estimated costs"
  value       = "Standard_B2s VM in ${azurerm_resource_group.main.location} costs approximately $30-60/month. Remember to destroy resources when not needed!"
}
