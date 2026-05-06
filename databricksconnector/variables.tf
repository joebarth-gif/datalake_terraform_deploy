variable "access_connector_name" {
  type = string
}
variable "azure_client_id" {
  description = "The Azure client id"
}
variable "azure_client_secret" {
  description = "The Azure client secret"
}
variable "azure_region" {
  description = "The Azure region in which we will operate"
}
variable "azure_subscription" {
  description = "The Azure subscription in which we will operate"
}
variable "azure_tenant" {
  description = "The Azure tenant in which we will operate"
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "databricks_workspace_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
