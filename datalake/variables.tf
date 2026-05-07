variable "access_connector_name" {
  type = string
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
variable "workspace_name" {}
variable "metastore_name" {}
variable "account_id" {}
variable "metastore_id" {}
