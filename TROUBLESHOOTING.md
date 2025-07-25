# Troubleshooting Guide

## Common Issues and Solutions

### 1. Authentication Issues

#### Problem: "Error building account"
```
Error: Error building account: Error building AzureRM Client: obtain subscription() from Azure CLI: parsing json result from the Azure CLI: waiting for the Azure CLI: exit status 1: ERROR: Please run 'az login' to setup account.
```

**Solution:**
```bash
az login
# If you have multiple subscriptions, set the correct one:
az account set --subscription "your-subscription-id"
```

#### Problem: Insufficient permissions
```
Error: authorization.RoleAssignmentsClient#Create: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailed"
```

**Solution:**
- Ensure your Azure account has Contributor or Owner permissions
- Contact your Azure administrator for proper permissions

### 2. Resource Naming Issues

#### Problem: Resource name already exists
```
Error: A resource with the ID "/subscriptions/.../resourceGroups/rg-terraform-exercise" already exists
```

**Solution:**
```bash
# Option 1: Use a different resource group name in terraform.tfvars
resource_group_name = "rg-terraform-exercise-2"

# Option 2: Import existing resource
terraform import azurerm_resource_group.main /subscriptions/your-sub-id/resourceGroups/existing-rg-name

# Option 3: Delete existing resource group (if safe to do so)
az group delete --name rg-terraform-exercise
```

### 3. VM Size and Quota Issues

#### Problem: VM size not available in region
```
Error: compute.VirtualMachinesClient#CreateOrUpdate: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="SkuNotAvailable"
```

**Solution:**
```bash
# Check available VM sizes in your region
az vm list-sizes --location "East US" --output table

# Update terraform.tfvars with available size
vm_size = "Standard_B1s"  # or another available size
```

#### Problem: Quota exceeded
```
Error: Operation could not be completed as it results in exceeding approved Core quota
```

**Solution:**
- Check your quotas in Azure Portal: Subscriptions → Usage + quotas
- Request quota increase if needed
- Use smaller VM size temporarily

### 4. Network Configuration Issues

#### Problem: Subnet address conflicts
```
Error: The subnet address space 10.0.1.0/24 overlaps with existing subnet
```

**Solution:**
- Change the subnet CIDR in main.tf
- Use a different IP range like 10.1.0.0/16

### 5. SSH Connection Issues

#### Problem: Can't connect via SSH
```
ssh: connect to host x.x.x.x port 22: Connection timed out
```

**Troubleshooting steps:**
1. Check if VM is running:
   ```bash
   az vm get-instance-view --resource-group rg-terraform-exercise --name vm-terraform-demo --query instanceView.statuses
   ```

2. Check Network Security Group rules:
   ```bash
   az network nsg rule list --resource-group rg-terraform-exercise --nsg-name nsg-vm-terraform-demo --output table
   ```

3. Verify public IP:
   ```bash
   terraform output public_ip_address
   ```

4. Test connectivity:
   ```bash
   telnet <public-ip> 22
   ```

### 6. Terraform State Issues

#### Problem: State file corruption
```
Error: Failed to load state: state file corrupt
```

**Solution:**
```bash
# Backup current state
cp terraform.tfstate terraform.tfstate.backup

# Try to recover from backup
cp terraform.tfstate.backup terraform.tfstate

# If that fails, reimport resources
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/rg-name
```

#### Problem: Resource exists but not in state
```
Error: A resource with the ID "..." already exists - to be managed via Terraform this resource needs to be imported
```

**Solution:**
```bash
# Import the resource
terraform import azurerm_linux_virtual_machine.main /subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/vm-name
```

### 7. Cost Management

#### Problem: Unexpected charges
- Check Azure Cost Management in the portal
- Set up billing alerts
- Remember to destroy resources when not needed:
  ```bash
  terraform destroy
  ```

### 8. Windows-Specific Issues

#### Problem: PowerShell execution policy
```
cannot be loaded because running scripts is disabled on this system
```

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Problem: Line ending issues
**Solution:**
```bash
# Convert line endings if needed
dos2unix setup.sh
```

## Useful Commands

### Terraform Commands
```bash
# Initialize and download providers
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Plan changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources
terraform state list

# Get specific output
terraform output public_ip_address

# Destroy all resources
terraform destroy
```

### Azure CLI Commands
```bash
# Login
az login

# List subscriptions
az account list --output table

# Set subscription
az account set --subscription "subscription-name-or-id"

# List resource groups
az group list --output table

# List VMs
az vm list --output table

# Get VM status
az vm get-instance-view --resource-group rg-name --name vm-name

# SSH to VM
az ssh vm --resource-group rg-name --name vm-name
```

## Getting Help

1. **Terraform Documentation**: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
2. **Azure CLI Documentation**: https://docs.microsoft.com/en-us/cli/azure/
3. **Azure Virtual Machines**: https://docs.microsoft.com/en-us/azure/virtual-machines/
4. **Terraform GitHub Issues**: https://github.com/hashicorp/terraform-provider-azurerm/issues

## Prevention Tips

1. **Always run `terraform plan` before `terraform apply`**
2. **Use consistent naming conventions**
3. **Tag your resources appropriately**
4. **Set up cost alerts in Azure**
5. **Use version control for your Terraform code**
6. **Keep Terraform and providers updated**
7. **Don't commit sensitive files (terraform.tfvars, .tfstate)**
