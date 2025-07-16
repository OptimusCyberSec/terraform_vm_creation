# Terraform Azure VM Exercise - Infrastructure as Code (IaC)

## Overview
This exercise teaches you how to build infrastructure in Azure using Terraform. You'll create a Linux virtual machine with proper networking, storage, and security configurations.

## What You'll Build
- **Virtual Network (VNet)** with a subnet
- **Linux Virtual Machine** (Kali Linux 2024.1)
- **Storage**: 100 GB managed disk
- **Compute**: Minimum 2 vCPUs
- **Security**: Network Security Group with SSH access
- **Public IP** for remote access

## Prerequisites

### 1. Install Required Tools
- [Terraform](https://www.terraform.io/downloads) (v1.0+)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- SSH client (for connecting to the VM)

### 2. Azure Authentication
```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "your-subscription-id"

# Verify your account
az account show
```

## Project Structure
```
terraform-vm-exercise/
├── README.md           # This guide
├── main.tf            # Main Terraform configuration
├── variables.tf       # Input variables
├── outputs.tf         # Output values
├── terraform.tfvars   # Variable values (create this)
└── .gitignore         # Git ignore file
```

## Step-by-Step Instructions

### Step 1: Clone or Download This Repository
```bash
git clone <your-repo-url>
cd terraform-vm-exercise
```

### Step 2: Configure Variables
Create a `terraform.tfvars` file with your specific values:

```hcl
# Copy terraform.tfvars.example to terraform.tfvars and customize
resource_group_name = "rg-terraform-exercise"
location           = "West Europe"
admin_username     = "azureuser"
vm_name           = "vm-terraform-demo"
```

### Step 3: Initialize Terraform
```bash
# Initialize Terraform (downloads Azure provider)
terraform init
```

### Step 4: Plan Your Infrastructure
```bash
# See what Terraform will create
terraform plan
```

### Step 5: Deploy Infrastructure
```bash
# Apply the configuration
terraform apply
```
Type `yes` when prompted to confirm the deployment.

### Step 6: Connect to Your VM
After deployment, Terraform will output the public IP address:

```bash
# SSH to your Kali Linux VM (replace with actual IP)
ssh azureuser@<public-ip-address>
```

**Note**: Kali Linux is a specialized penetration testing distribution. Make sure you comply with your organization's security policies when using it.

### Step 7: Verify Your Infrastructure
In the Azure Portal, navigate to your resource group to see:
- Virtual Machine
- Virtual Network and Subnet
- Network Security Group
- Public IP Address
- Managed Disks

### Step 8: Clean Up Resources
```bash
# Destroy all created resources
terraform destroy
```
Type `yes` when prompted to confirm the destruction.

## Network Configuration Details

### IP Ranges Used
- **VNet CIDR**: `10.0.0.0/16` (65,536 addresses)
- **Subnet CIDR**: `10.0.1.0/24` (256 addresses)

**Why this range is safe:**
- `10.0.0.0/8` is a private IP range (RFC 1918)
- Unlikely to conflict with on-premises networks
- Provides plenty of room for expansion

### Security Configuration
- **SSH Access**: Port 22 from any source (0.0.0.0/0)
- **Note**: In production, restrict SSH to specific IP ranges

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   # Re-login to Azure
   az login
   ```

2. **Resource Already Exists**
   ```bash
   # Import existing resource or change names in terraform.tfvars
   ```

3. **Quota Limits**
   - Check Azure quotas in the portal
   - Try a different VM size or region

### Terraform Commands Reference
```bash
# Initialize working directory
terraform init

# Validate configuration files
terraform validate

# Format configuration files
terraform fmt

# Show current state
terraform show

# List resources in state
terraform state list

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy
```

## Learning Objectives

After completing this exercise, you will understand:

1. **Terraform Basics**
   - Provider configuration
   - Resource definitions
   - Variable usage
   - Output values

2. **Azure Networking**
   - Virtual Networks and Subnets
   - Network Security Groups
   - Public IP addresses

3. **Azure Compute**
   - Virtual Machine sizing
   - Managed disks
   - SSH key authentication
   - Kali Linux deployment

4. **Infrastructure as Code**
   - Declarative infrastructure
   - State management
   - Resource dependencies

## Next Steps

1. **Enhance Security**
   - Add Key Vault for SSH keys
   - Implement Azure Bastion
   - Add monitoring and logging

2. **Scale the Infrastructure**
   - Add load balancer
   - Create multiple VMs
   - Implement auto-scaling

3. **Add Application Components**
   - Database services
   - Container services
   - Application Gateway

## Resources

- [Terraform Azure Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Virtual Networks](https://docs.microsoft.com/en-us/azure/virtual-network/)
- [Azure Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/)

---

**Happy Learning! 🚀**

Remember: Always clean up your resources after the exercise to avoid unnecessary costs.
