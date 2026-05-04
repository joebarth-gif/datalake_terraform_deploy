terraform {
  # 1.14.0 released 2025-11-19
  # 1.14.9 released 2026-04-20 (latest patch at time of writing)
  required_version = "~> 1.14.0"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "evocs_analytics"
    workspaces {
      prefix = "datalake_terraform_deploy_lakehouse"
    }
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # released 2026-04-23
      version = "~> 4.70.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.52.0"
    }
  }
}

# Configure the Microsoft Azure Resource Manager provider
#
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
  host  = module.adb-lakehouse.workspace_url
}
