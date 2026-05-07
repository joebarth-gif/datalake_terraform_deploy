data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

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
  allow_blob_public_access = false
}
resource "azurerm_storage_container" "container" {
  name                  = "unity-catalog"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
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

resource "azurerm_databricks_workspace" "this" {
  name                = var.databricks_workspace_name
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  sku = "premium"   # required for Unity Catalog

  managed_resource_group_name = "${var.databricks_workspace_name}-rg"

  tags = var.tags
}

resource "databricks_metastore" "metastore" {
  provider = databricks.account

  name   = var.metastore_name
  region = data.azurerm_resource_group.rg.location

  storage_root = "abfss://${azurerm_storage_container.container.name}@${azurerm_storage_account.storage.name}.dfs.core.windows.net/"
}
resource "databricks_storage_credential" "credential" {
  provider = databricks.workspace

  name = "uc-credential"

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.connector.id
  }
}

resource "databricks_external_location" "location" {
  provider = databricks.workspace

  name = "uc-location"

  url = "abfss://${azurerm_storage_container.container.name}@${azurerm_storage_account.storage.name}.dfs.core.windows.net/"

  credential_name = databricks_storage_credential.credential.name
}

resource "databricks_metastore_assignment" "assignment" {
  provider = databricks.account

  workspace_id = azurerm_databricks_workspace.workspace.workspace_id
  metastore_id = databricks_metastore.metastore.id

  default_catalog_name = "main"
}

resource "azurerm_role_assignment" "uc_storage_access" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}