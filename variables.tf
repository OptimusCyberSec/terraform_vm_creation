# Input Variables for Terraform Configuration
# These variables allow customization of the infrastructure deployment

# Resource Group Name
# The logical container for all our Azure resources
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-terraform-exercise"
  
  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }
}

# Azure Region/Location
# Where to deploy all the resources
variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "West Europe"
  
  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US",
      "West Central US", "Canada Central", "Canada East",
      "Brazil South", "North Europe", "West Europe", "UK South",
      "UK West", "France Central", "Germany West Central",
      "Switzerland North", "Norway East", "Sweden Central",
      "Australia East", "Australia Southeast", "Southeast Asia",
      "East Asia", "Japan East", "Japan West", "Korea Central",
      "Korea South", "India Central", "India South", "India West"
    ], var.location)
    error_message = "Please provide a valid Azure region."
  }
}

# Virtual Machine Name
# Base name used for VM and related resources
variable "vm_name" {
  description = "Name of the virtual machine (used as prefix for related resources)"
  type        = string
  default     = "vm-terraform-demo"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,15}$", var.vm_name))
    error_message = "VM name must be 1-15 characters and contain only letters, numbers, and hyphens."
  }
}

# Administrator Username
# Username for the VM admin account
variable "admin_username" {
  description = "Administrator username for the virtual machine"
  type        = string
  default     = "azureuser"
  
  validation {
    condition = can(regex("^[a-zA-Z][a-zA-Z0-9]{1,19}$", var.admin_username)) && !contains([
      "administrator", "admin", "user", "user1", "test", "user2",
      "test1", "user3", "admin1", "1", "123", "a", "actuser",
      "adm", "admin2", "aspnet", "backup", "console", "david",
      "guest", "john", "owner", "root", "server", "sql",
      "support", "support_388945a0", "sys", "test2", "test3",
      "user4", "user5"
    ], lower(var.admin_username))
    error_message = "Admin username must be 1-20 characters, start with a letter, contain only letters and numbers, and not be a reserved name."
  }
}

# VM Size
# Azure VM size (SKU) to determine CPU, memory, and other specs
variable "vm_size" {
  description = "Size (SKU) of the virtual machine"
  type        = string
  default     = "Standard_B2s"  # 2 vCPUs, 4 GB RAM, burstable performance
  
  validation {
    condition = contains([
      "Standard_B1s", "Standard_B1ms", "Standard_B2s", "Standard_B2ms",
      "Standard_B4ms", "Standard_D2s_v3", "Standard_D4s_v3",
      "Standard_DS1_v2", "Standard_DS2_v2", "Standard_F2s_v2"
    ], var.vm_size)
    error_message = "Please select a valid VM size that meets the minimum 2 vCPU requirement."
  }
}

# Data Disk Size
# Size of the additional data disk in GB
variable "data_disk_size_gb" {
  description = "Size of the data disk in GB"
  type        = number
  default     = 100
  
  validation {
    condition     = var.data_disk_size_gb >= 32 && var.data_disk_size_gb <= 4095
    error_message = "Data disk size must be between 32 GB and 4095 GB."
  }
}

# Environment Tag
# Used for resource tagging and organization
variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "Development"
  
  validation {
    condition = contains([
      "Development", "Testing", "Staging", "Production"
    ], var.environment)
    error_message = "Environment must be one of: Development, Testing, Staging, Production."
  }
}

# Project Tag
# Project identifier for cost tracking and organization
variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "Terraform-Exercise"
  
  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 50
    error_message = "Project name must be between 1 and 50 characters."
  }
}
