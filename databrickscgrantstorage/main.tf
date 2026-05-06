data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}
resource "azurerm_databricks_access_connector" "this" {
  name                = var.access_connector_name
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.existing.name
  location                 = data.azurerm_resource_group.existing.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

resource "azurerm_databricks_workspace" "this" {
  name                = var.databricks_workspace_name
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  sku = "premium"   # required for Unity Catalog

  managed_resource_group_name = "${var.databricks_workspace_name}-rg"

  tags = var.tags
}

resource "azurerm_role_assignment" "uc_storage_access" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}