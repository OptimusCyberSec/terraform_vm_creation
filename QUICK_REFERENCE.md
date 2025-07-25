# Terraform Azure VM - Quick Reference Card

## Prerequisites Checklist
- [ ] Terraform installed (`terraform --version`)
- [ ] Azure CLI installed (`az --version`)
- [ ] Logged into Azure (`az login`)
- [ ] Subscription selected (`az account show`)

## Essential Commands

### Setup
```bash
# 1. Copy variables file
cp terraform.tfvars.example terraform.tfvars

# 2. Edit terraform.tfvars with your values
# 3. Initialize Terraform
terraform init

# 4. Validate configuration
terraform validate

# 5. Plan deployment
terraform plan

# 6. Deploy infrastructure
terraform apply
```

### Management
```bash
# View current state
terraform show

# List all resources
terraform state list

# Get outputs
terraform output

# Format code
terraform fmt

# Destroy everything
terraform destroy
```

## Key Outputs After Deployment
- **Public IP**: `terraform output public_ip_address`
- **SSH Command**: `terraform output ssh_connection_command`
- **Private Key**: `terraform output -raw ssh_private_key > private_key.pem`

## SSH Connection
```bash
# Get private key
terraform output -raw ssh_private_key > private_key.pem
chmod 600 private_key.pem

# Connect to Kali Linux VM
ssh -i private_key.pem azureuser@$(terraform output -raw public_ip_address)
```

## Common Customizations

### Change VM Size
```hcl
# In terraform.tfvars
vm_size = "Standard_B4ms"  # 4 vCPUs, 16 GB RAM
```

### Change Region
```hcl
# In terraform.tfvars
location = "West Europe"
```

### Change Disk Size
```hcl
# In terraform.tfvars
data_disk_size_gb = 200  # 200 GB instead of 100 GB
```

## Resource Naming Pattern
- Resource Group: `rg-{vm_name}`
- Virtual Network: `vnet-{vm_name}`
- Subnet: `subnet-{vm_name}`
- Public IP: `pip-{vm_name}`
- Network Security Group: `nsg-{vm_name}`
- Network Interface: `nic-{vm_name}`
- Data Disk: `disk-{vm_name}-data`

## Network Configuration
- **VNet CIDR**: 10.0.0.0/16 (65,536 IPs)
- **Subnet CIDR**: 10.0.1.0/24 (256 IPs)
- **SSH Port**: 22 (open to 0.0.0.0/0)

## Cost Optimization
- **Standard_B2s**: ~$30-60/month
- **Remember**: Run `terraform destroy` when done!
- **Monitor**: Check Azure Cost Management

## File Structure
```
terraform-vm-exercise/
├── README.md              # Detailed guide
├── TROUBLESHOOTING.md     # Common issues
├── main.tf               # Main configuration
├── variables.tf          # Variable definitions
├── outputs.tf            # Output values
├── terraform.tfvars      # Your values (create this)
├── terraform.tfvars.example  # Example values
├── setup.sh              # Setup script (Linux/Mac)
├── setup.ps1             # Setup script (Windows)
└── .gitignore            # Git ignore rules
```

## Emergency Commands
```bash
# If something goes wrong
terraform destroy -auto-approve

# Force unlock (if needed)
terraform force-unlock LOCK_ID

# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/SUB_ID/resourceGroups/RG_NAME
```

## Useful Azure CLI Commands
```bash
# List VMs
az vm list --output table

# Get VM status
az vm get-instance-view --resource-group rg-name --name vm-name

# Start/Stop VM
az vm start --resource-group rg-name --name vm-name
az vm stop --resource-group rg-name --name vm-name

# Delete resource group
az group delete --name rg-name --yes --no-wait
```
