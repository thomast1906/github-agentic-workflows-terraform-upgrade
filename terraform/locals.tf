locals {
  name_prefix = lower(replace("${var.project_name}-${var.environment}", "-", ""))

  resource_group_name = "rg-${var.project_name}-${var.environment}-${random_string.suffix.result}"
  storage_account_name = substr(
    "st${local.name_prefix}${random_string.suffix.result}",
    0,
    24
  )
  key_vault_name = substr(
    "kv-${var.project_name}-${var.environment}-${random_string.suffix.result}",
    0,
    24
  )

  app_service_plan_name = "asp-${var.project_name}-${var.environment}-${random_string.suffix.result}"
  linux_web_app_name    = "app-${var.project_name}-${var.environment}-${random_string.suffix.result}"

  vnet_name   = "vnet-${var.project_name}-${var.environment}-${random_string.suffix.result}"
  subnet_name = "snet-app"
  nsg_name    = "nsg-${var.project_name}-${var.environment}-${random_string.suffix.result}"

  sql_server_name   = substr("sql-${var.project_name}-${var.environment}-${random_string.suffix.result}", 0, 63)
  sql_database_name = "sqldb-${var.project_name}-${var.environment}"

  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Purpose     = "Testing GitHub Agentic Workflows"
      Project     = var.project_name
    },
    var.tags
  )
}
