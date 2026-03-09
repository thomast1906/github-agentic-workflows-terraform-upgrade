resource "random_password" "sql_admin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "azurerm_mssql_server" "example" {
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

moved {
  from = azurerm_sql_server.example
  to   = azurerm_mssql_server.example
}

resource "azurerm_mssql_database" "example" {
  name      = local.sql_database_name
  server_id = azurerm_mssql_server.example.id
  sku_name  = "Basic"

  tags = local.common_tags
}

moved {
  from = azurerm_sql_database.example
  to   = azurerm_mssql_database.example
}

resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.example.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

moved {
  from = azurerm_sql_firewall_rule.azure_services
  to   = azurerm_mssql_firewall_rule.azure_services
}

# Store SQL admin password in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin.result
  key_vault_id = azurerm_key_vault.example.id
}
