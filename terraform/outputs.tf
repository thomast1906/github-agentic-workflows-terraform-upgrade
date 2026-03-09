output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.example.name
}

output "storage_account_name" {
  description = "The name of the created storage account"
  value       = azurerm_storage_account.example.name
}

output "virtual_network_name" {
  description = "The name of the created virtual network"
  value       = azurerm_virtual_network.example.name
}

output "linux_web_app_name" {
  description = "The name of the created Linux Web App"
  value       = azurerm_linux_web_app.example.name
}

output "key_vault_name" {
  description = "The name of the created Key Vault"
  value       = azurerm_key_vault.example.name
}

output "sql_server_name" {
  description = "The name of the created SQL Server"
  value       = azurerm_mssql_server.example.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.example.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "The name of the created SQL Database"
  value       = azurerm_mssql_database.example.name
}
