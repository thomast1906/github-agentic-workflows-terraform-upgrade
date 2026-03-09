resource "random_password" "sql_admin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

# Deprecated in azurerm 3.x — replaced by azurerm_mssql_server in 4.x
resource "azurerm_sql_server" "example" {
  name                         = local.sql_server_name
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = random_password.sql_admin.result

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Deprecated in azurerm 3.x — replaced by azurerm_mssql_database in 4.x
resource "azurerm_sql_database" "example" {
  name                             = local.sql_database_name
  resource_group_name              = azurerm_resource_group.example.name
  location                         = azurerm_resource_group.example.location
  server_name                      = azurerm_sql_server.example.name
  edition                          = "Basic"
  requested_service_objective_name = "Basic"

  tags = local.common_tags
}

# Allow Azure services to access the SQL Server
# Deprecated in azurerm 3.x — replaced by azurerm_mssql_firewall_rule in 4.x
resource "azurerm_sql_firewall_rule" "azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_sql_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Store SQL admin password in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin.result
  key_vault_id = azurerm_key_vault.example.id
}
