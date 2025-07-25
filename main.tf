# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  
  # Specify minimum Terraform version
  required_version = ">= 1.0"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Create a resource group
# This is a logical container for all our resources
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  
  # Tags help organize and track resources
  tags = {
    Environment = var.environment
    Project     = var.project_name
    CreatedBy   = "Terraform"
  }
}

# Create a virtual network
# This provides isolated network environment for our resources
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.vm_name}"
  address_space       = ["10.0.0.0/16"]  # Private IP range, 65,536 addresses
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create a subnet within the virtual network
# Subnets segment the VNet for better organization and security
resource "azurerm_subnet" "internal" {
  name                 = "subnet-${var.vm_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]  # 256 addresses available
}

# Create a public IP address
# This allows our VM to be accessible from the internet
resource "azurerm_public_ip" "main" {
  name                = "pip-${var.vm_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"  # IP won't change when VM is stopped/started
  sku                = "Standard"
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create a Network Security Group (NSG) and rules
# NSG acts as a firewall to control network traffic
resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.vm_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  # Allow SSH traffic from anywhere (port 22)
  # WARNING: In production, restrict source_address_prefix to specific IPs
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"  # Allow from anywhere
    destination_address_prefix = "*"
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create a network interface
# This connects our VM to the subnet and public IP
resource "azurerm_network_interface" "main" {
  name                = "nic-${var.vm_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  # Configure IP settings
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"  # Azure assigns IP automatically
    public_ip_address_id          = azurerm_public_ip.main.id
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Associate the Network Security Group to the network interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Generate SSH key pair for secure authentication
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  # VM size with minimum 2 vCPUs
  # Standard_B2s = 2 vCPUs, 4 GB RAM (burstable performance)
  size = var.vm_size
  
  # Disable password authentication for better security
  disable_password_authentication = true
  
  # Network interface configuration
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]
  
  # Administrator account configuration
  admin_username = var.admin_username
  
  # SSH key configuration for secure access
  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.ssh.public_key_openssh
  }
  
  # Operating system configuration
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"  # SSD for better performance
  }
  
  # Source image configuration - Kali Linux
  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = "kali-2024-1"
    version   = "latest"
  }
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create a managed disk for additional storage (100 GB)
resource "azurerm_managed_disk" "data" {
  name                 = "disk-${var.vm_name}-data"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Premium_LRS"  # SSD storage
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Attach the data disk to the virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  managed_disk_id    = azurerm_managed_disk.data.id
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  lun                = "10"  # Logical Unit Number
  caching            = "ReadWrite"
}
