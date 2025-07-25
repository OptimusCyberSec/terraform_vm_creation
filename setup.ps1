# Terraform Azure VM Exercise Setup Script (PowerShell)
# This script helps you get started with the exercise

Write-Host "🚀 Terraform Azure VM Exercise Setup" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Check if Terraform is installed
if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Terraform is not installed. Please install Terraform first:" -ForegroundColor Red
    Write-Host "   https://www.terraform.io/downloads" -ForegroundColor Yellow
    exit 1
}

# Check if Azure CLI is installed
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Azure CLI is not installed. Please install Azure CLI first:" -ForegroundColor Red
    Write-Host "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Terraform and Azure CLI are installed" -ForegroundColor Green

# Check if user is logged into Azure
try {
    az account show --output none
    Write-Host "✅ You are logged into Azure" -ForegroundColor Green
}
catch {
    Write-Host "❌ You are not logged into Azure. Please run:" -ForegroundColor Red
    Write-Host "   az login" -ForegroundColor Yellow
    exit 1
}

# Display current subscription
Write-Host ""
Write-Host "📋 Current Azure Subscription:" -ForegroundColor Cyan
az account show --output table --query '[Name, Id, State]'

Write-Host ""
Write-Host "🔧 Setting up Terraform configuration..." -ForegroundColor Cyan

# Create terraform.tfvars if it doesn't exist
if (-not (Test-Path "terraform.tfvars")) {
    Write-Host "📝 Creating terraform.tfvars from example..." -ForegroundColor Yellow
    Copy-Item "terraform.tfvars.example" "terraform.tfvars"
    Write-Host "✅ terraform.tfvars created. Please edit it with your preferred values." -ForegroundColor Green
} else {
    Write-Host "✅ terraform.tfvars already exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Edit terraform.tfvars with your preferred values" -ForegroundColor White
Write-Host "2. Run: terraform init" -ForegroundColor White
Write-Host "3. Run: terraform plan" -ForegroundColor White
Write-Host "4. Run: terraform apply" -ForegroundColor White
Write-Host ""
Write-Host "📖 See README.md for detailed instructions" -ForegroundColor Yellow
Write-Host ""
Write-Host "Happy learning! 🎉" -ForegroundColor Green
