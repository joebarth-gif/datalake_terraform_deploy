data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version          = "TLS1_2"

  is_hns_enabled = true
}
resource "azurerm_storage_container" "container" {
  name                  = "unity-catalog"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
resource "azurerm_databricks_access_connector" "this" {
  name                = var.access_connector_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_databricks_workspace" "this" {
  name                = var.databricks_workspace_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku = "premium"   # required for Unity Catalog

  managed_resource_group_name = "${var.databricks_workspace_name}-rg"

  tags = var.tags
}


resource "databricks_metastore_assignment" "assignment" {
  provider = databricks.account

  workspace_id = azurerm_databricks_workspace.this.workspace_id
  metastore_id = var.metastore_id

  default_catalog_name = "main"

  depends_on = [
    azurerm_databricks_workspace.this
  ]
}

resource "azurerm_role_assignment" "uc_storage_access" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}