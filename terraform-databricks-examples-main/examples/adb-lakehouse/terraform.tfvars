subscription_id = "d3c715b6-e3e5-4e21-9d3e-d919adc08502"
account_id      = "37c64ae8-f8f8-42e7-b0e7-3271fc6d0225"

location                        = "canadacentral"
existing_resource_group_name    = "db_lh_example_rg"
project_name                    = "db_lh_example"
environment_name                = "db_lh_example_env"
databricks_workspace_name       = "db_lh_example_ws"
spoke_vnet_address_space        = "10.178.0.0/16"
private_subnet_address_prefixes = ["10.178.0.0/20"]
public_subnet_address_prefixes  = ["10.178.16.0/20"]
shared_resource_group_name      = "db_lh_example_shared_rg"
metastore_name                  = "db_lh_metastore"
metastore_storage_name          = "dblhmetastorestorage2"
access_connector_name           = "db_lh_example_connector"
landing_external_location_name  = "dblhexamplelanding2"
landing_adls_path               = "abfss://example@dblhexamplelanding2.dfs.core.windows.net"
landing_adls_rg                 = "dblhexamplelanding"
metastore_admins                = ["joe.barth@evocs.tech"]

tags = {
  Owner = "joe.barth@evocs.tech"
}