output "access_connector_id" {
  value = azurerm_databricks_access_connector.this.id
}

output "access_connector_principal_id" {
  value = azurerm_databricks_access_connector.this.identity[0].principal_id
}
output "workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}