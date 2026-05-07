terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.40"
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
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.account_id
}

provider "databricks" {
  alias = "workspace"
  host  = azurerm_databricks_workspace.this.workspace_url
}