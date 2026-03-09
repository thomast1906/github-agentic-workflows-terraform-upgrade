# Terraform Provider Upgrade: AzureRM v3.75.0 → v4.63.0

**Date:** 2026-03-09

## Summary

Upgraded HashiCorp AzureRM provider from v3.75.0 to v4.63.0 and Random provider from v3.5.0 to v3.8.1. The AzureRM major version upgrade included automatic migration of deprecated SQL resources to their modern MSSQL equivalents.

## What Changed

- **AzureRM Provider**: Updated from `~> 3.75.0` to `~> 4.63.0`
- **Random Provider**: Updated from `~> 3.5.0` to `~> 3.8.0` (non-breaking)
- **Resource Migrations**: Migrated deprecated `azurerm_sql_*` resources → `azurerm_mssql_*`
- **Moved Blocks**: Added automatic state migration for seamless upgrade

## Breaking Changes Handled

### ✅ 1. azurerm_sql_server → azurerm_mssql_server

**Files Modified:** `terraform/sql.tf`, `terraform/outputs.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_server` to `azurerm_mssql_server`
- Added `moved` block for automatic state migration
- All arguments remain compatible (no schema changes required)
- Updated output references to use new resource type

**Argument Mappings:**
- All arguments are compatible between old and new resource types
- No breaking argument changes in this migration
- `name`, `resource_group_name`, `location`, `version`, `administrator_login`, `administrator_login_password`, `identity`, and `tags` all remain unchanged

**Default Values:**
- No new default value changes affect existing configuration
- `minimum_tls_version` defaults to `1.2` in v4 (recommended security practice)

**Documentation:** [azurerm_mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server)

---

### ✅ 2. azurerm_sql_database → azurerm_mssql_database

**Files Modified:** `terraform/sql.tf`, `terraform/outputs.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_database` to `azurerm_mssql_database`
- Changed `server_name` argument to `server_id` (now requires full resource ID)
- Removed deprecated `edition` and `requested_service_objective_name` arguments
- Replaced with `sku_name = "Basic"` (equivalent configuration)
- Removed `resource_group_name` and `location` (inherited from server)
- Added `moved` block for automatic state migration
- Updated output references to use new resource type

**Argument Mappings:**
- `server_name` → `server_id`: Now uses `azurerm_mssql_server.example.id`
- `edition = "Basic"` + `requested_service_objective_name = "Basic"` → `sku_name = "Basic"`
- `resource_group_name` (removed): Inherited from parent server
- `location` (removed): Inherited from parent server
- `name` and `tags` remain unchanged

**Default Values:**
- No new default value changes affect existing configuration

**Documentation:** [azurerm_mssql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)

---

### ✅ 3. azurerm_sql_firewall_rule → azurerm_mssql_firewall_rule

**Files Modified:** `terraform/sql.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_firewall_rule` to `azurerm_mssql_firewall_rule`
- Changed `server_name` argument to `server_id` (now requires full resource ID)
- Removed `resource_group_name` argument (no longer needed with `server_id`)
- Updated reference from `.name` to `.id` for server
- Added `moved` block for automatic state migration

**Argument Mappings:**
- `resource_group_name` (removed) + `server_name` → `server_id`
- Now uses: `azurerm_mssql_server.example.id`
- `name`, `start_ip_address`, and `end_ip_address` remain unchanged

**Default Values:**
- No new default value changes affect existing configuration

**Documentation:** [azurerm_mssql_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule)

---

## Deprecations

**No deprecated arguments/resources detected** beyond the removed SQL resources that have been migrated above.

## State Migration

All migrations use Terraform's `moved` blocks for automatic state migration:

```hcl
moved {
  from = azurerm_sql_server.example
  to   = azurerm_mssql_server.example
}

moved {
  from = azurerm_sql_database.example
  to   = azurerm_mssql_database.example
}

moved {
  from = azurerm_sql_firewall_rule.azure_services
  to   = azurerm_mssql_firewall_rule.azure_services
}
```

When you run `terraform plan`, Terraform will automatically migrate the state without requiring manual `terraform state mv` commands.

## Other Notable Changes in AzureRM v4.0

### Provider Configuration Changes
- **Resource Provider Registration**: The provider now uses a more flexible RP registration system
  - Default behavior matches v3.x (`resource_provider_registrations = "legacy"` implied)
  - No action required for existing configurations

### Non-Breaking Enhancements
- **Provider Functions**: New functions available: `normalise_resource_id` and `parse_resource_id`
- **Subscription ID**: Now mandatory (already specified via Azure CLI or environment variable)
- **AKS Updates**: Migration to stable APIs (no AKS resources in this configuration)

See the [AzureRM 4.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide) for complete details.

## Next Steps

1. ✅ **Changes have been applied** - All code migrations are complete
2. **Commit and push** this branch to trigger CI/CD pipeline
3. **Review plan output** in your pipeline to confirm state migrations
4. **Verify no unexpected changes** before merging to main
5. **Terraform will automatically migrate state** using the `moved` blocks on first apply

## Pipeline Validation

Your CI/CD pipeline will:
- Run `terraform init` to download the new provider versions
- Run `terraform plan` to show the state migrations
- Show `moved` operations for each migrated resource
- Confirm no infrastructure changes (only state updates)

## References

- [AzureRM Provider 4.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide)
- [AzureRM Provider v4.63.0 Release Notes](https://github.com/hashicorp/terraform-provider-azurerm/releases/tag/v4.63.0)
- [Terraform Moved Blocks Documentation](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring)
- [azurerm_mssql_server Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server)
- [azurerm_mssql_database Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)
- [azurerm_mssql_firewall_rule Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule)
