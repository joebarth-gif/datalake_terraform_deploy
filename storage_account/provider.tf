terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.azure_tenant
  subscription_id = var.azure_subscription
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  use_cli         = false
  features {}
}