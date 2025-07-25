#!/bin/bash

# Terraform Azure VM Exercise Setup Script
# This script helps you get started with the exercise

echo "🚀 Terraform Azure VM Exercise Setup"
echo "====================================="

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform first:"
    echo "   https://www.terraform.io/downloads"
    exit 1
fi

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install Azure CLI first:"
    echo "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

echo "✅ Terraform and Azure CLI are installed"

# Check if user is logged into Azure
if ! az account show &> /dev/null; then
    echo "❌ You are not logged into Azure. Please run:"
    echo "   az login"
    exit 1
fi

echo "✅ You are logged into Azure"

# Display current subscription
echo ""
echo "📋 Current Azure Subscription:"
az account show --output table --query '[Name, Id, State]'

echo ""
echo "🔧 Setting up Terraform configuration..."

# Create terraform.tfvars if it doesn't exist
if [ ! -f "terraform.tfvars" ]; then
    echo "📝 Creating terraform.tfvars from example..."
    cp terraform.tfvars.example terraform.tfvars
    echo "✅ terraform.tfvars created. Please edit it with your preferred values."
else
    echo "✅ terraform.tfvars already exists"
fi

echo ""
echo "🎯 Next Steps:"
echo "1. Edit terraform.tfvars with your preferred values"
echo "2. Run: terraform init"
echo "3. Run: terraform plan"
echo "4. Run: terraform apply"
echo ""
echo "📖 See README.md for detailed instructions"
echo ""
echo "Happy learning! 🎉"
