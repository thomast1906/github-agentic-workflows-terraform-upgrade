# Terraform Provider Upgrade: AzureRM v3.75.0 → v4.63.0

**Date:** 2026-03-10  
**Upgrade Type:** Major Version (Breaking Changes)

## Summary

Upgraded HashiCorp AzureRM provider from `~> 3.75.0` to `~> 4.63.0` and Random provider from `~> 3.5.0` to `~> 3.8.0`. This major version upgrade included automatic migration of deprecated SQL resources to their modern MSSQL equivalents with proper state migration using `moved` blocks.

## What Changed

### Version Updates
- **AzureRM Provider:** `~> 3.75.0` → `~> 4.63.0` (major version upgrade)
- **Random Provider:** `~> 3.5.0` → `~> 3.8.0` (minor version upgrade, non-breaking)

### Resource Migrations Applied
- Migrated `azurerm_sql_server` → `azurerm_mssql_server`
- Migrated `azurerm_sql_database` → `azurerm_mssql_database`
- Migrated `azurerm_sql_firewall_rule` → `azurerm_mssql_firewall_rule`

## Breaking Changes Handled

### ✅ 1. azurerm_sql_server → azurerm_mssql_server

**Files Modified:** `terraform/sql.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_server` to `azurerm_mssql_server`
- Added `moved` block for automatic state migration
- All arguments remain compatible (no schema changes required)

**Argument Mappings:**
- ✅ `name` - No change
- ✅ `resource_group_name` - No change
- ✅ `location` - No change
- ✅ `version` - No change
- ✅ `administrator_login` - No change
- ✅ `administrator_login_password` - No change
- ✅ `identity` block - No change
- ✅ `tags` - No change

**Default Values:** No new default value changes that affect existing behavior.

**Documentation:** [azurerm_mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/4.63.0/docs/resources/mssql_server)

---

### ✅ 2. azurerm_sql_database → azurerm_mssql_database

**Files Modified:** `terraform/sql.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_database` to `azurerm_mssql_database`
- Replaced `resource_group_name`, `location`, `server_name` with `server_id`
- Mapped `edition="Basic"` + `requested_service_objective_name="Basic"` to `sku_name="Basic"`
- Added `moved` block for automatic state migration

**Argument Mappings:**
- ✅ `name` → `name` (no change)
- ❌ `resource_group_name` (removed) + `location` (removed) + `server_name` (removed)
- ✅ `server_id` (new) - Now uses: `azurerm_mssql_server.example.id`
- ❌ `edition` (removed) + `requested_service_objective_name` (removed)
- ✅ `sku_name` (new) - Mapped from `edition` + `requested_service_objective_name` → `"Basic"`
- ✅ `tags` - No change

**SKU Mapping:**
- Old: `edition = "Basic"` + `requested_service_objective_name = "Basic"`
- New: `sku_name = "Basic"`

**Default Values:** No new default value changes that affect existing behavior.

**Documentation:** [azurerm_mssql_database](https://registry.terraform.io/providers/hashicorp/azurerm/4.63.0/docs/resources/mssql_database)

---

### ✅ 3. azurerm_sql_firewall_rule → azurerm_mssql_firewall_rule

**Files Modified:** `terraform/sql.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_firewall_rule` to `azurerm_mssql_firewall_rule`
- Replaced `resource_group_name` + `server_name` with `server_id`
- Updated reference from name-based to ID-based
- Added `moved` block for automatic state migration

**Argument Mappings:**
- ✅ `name` → `name` (no change)
- ❌ `resource_group_name` (removed) + `server_name` (removed)
- ✅ `server_id` (new) - Now uses: `azurerm_mssql_server.example.id`
- ✅ `start_ip_address` - No change
- ✅ `end_ip_address` - No change

**Default Values:** No new default value changes that affect existing behavior.

**Documentation:** [azurerm_mssql_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/4.63.0/docs/resources/mssql_firewall_rule)

---

## State Migration

All resources include `moved` blocks that enable **automatic state migration** on the next `terraform plan` or `terraform apply`. No manual `terraform state mv` commands are required.

Example of moved block:
````hcl
moved {
  from = azurerm_sql_server.example
  to   = azurerm_mssql_server.example
}
````

## Deprecations

### Auto-Fixed Deprecations

**1. SQL Resource Types (Removed in v4.0)**
- **Item:** `azurerm_sql_server`, `azurerm_sql_database`, `azurerm_sql_firewall_rule`
- **Context:** `terraform/sql.tf` - All SQL resources
- **Replacement:** `azurerm_mssql_server`, `azurerm_mssql_database`, `azurerm_mssql_firewall_rule`
- **Status:** ✅ `applied` - Migrated with `moved` blocks for automatic state migration
- **Reason:** These resources were removed in AzureRM v4.0 and replaced with modern MSSQL equivalents

### No Other Deprecations Found

No other deprecated arguments, blocks, or resources were detected in the codebase.

## Provider Block Changes

No changes required to the provider block. The existing configuration is compatible with v4.x:

````hcl
provider "azurerm" {
  features {}
}
````

**Note:** AzureRM v4.0 introduces new `resource_provider_registrations` options, but the default behavior remains compatible with existing configurations.

## Next Steps

1. **Review this documentation** to understand all changes made
2. **Run Terraform workflow via CI/CD pipeline** to validate the upgrade
3. **Review plan output** - You should see messages about state migrations using `moved` blocks:
   ````
   azurerm_mssql_server.example has moved to azurerm_mssql_server.example
   azurerm_mssql_database.example has moved to azurerm_mssql_database.example
   azurerm_mssql_firewall_rule.azure_services has moved to azurerm_mssql_firewall_rule.azure_services
   ````
4. **Verify no unexpected changes** before merging to main branch
5. **Apply changes** via pipeline when ready

## References

- [AzureRM Provider v4.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide)
- [AzureRM Provider v4.63.0 Release Notes](https://github.com/hashicorp/terraform-provider-azurerm/releases/tag/v4.63.0)
- [Terraform Moved Blocks Documentation](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring)
- [azurerm_mssql_server Resource](https://registry.terraform.io/providers/hashicorp/azurerm/4.63.0/docs/resources/mssql_server)
- [azurerm_mssql_database Resource](https://registry.terraform.io/providers/hashicorp/azurerm/4.63.0/docs/resources/mssql_database)
- [azurerm_mssql_firewall_rule Resource](https://registry.terraform.io/providers/hashicorp/azurerm/4.63.0/docs/resources/mssql_firewall_rule)

---

**Upgrade completed by:** GitHub Agentic Workflows Terraform Upgrade Agent  
**Methodology:** Automatic code migration with moved blocks for zero-downtime state migration
