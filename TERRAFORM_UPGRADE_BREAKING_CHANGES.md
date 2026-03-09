# Terraform Provider Upgrade: AzureRM v3.75.0 → v4.63.0

**Date:** 2026-03-09

## Summary

Upgraded HashiCorp AzureRM provider from v3.75.0 to v4.63.0 and Random provider from v3.5.0 to v3.8.1. This major version upgrade included automatic migration of removed SQL resources to their modern MSSQL equivalents.

## What Changed

- Updated `azurerm` provider version constraint from `~> 3.75.0` to `~> 4.63.0`
- Updated `random` provider version constraint from `~> 3.5.0` to `~> 3.8.1`
- Migrated deprecated SQL resources to MSSQL equivalents:
  - `azurerm_sql_server` → `azurerm_mssql_server`
  - `azurerm_sql_database` → `azurerm_mssql_database`
  - `azurerm_sql_firewall_rule` → `azurerm_mssql_firewall_rule`
- Updated output references to use new resource types
- Added `moved` blocks for automatic state migration

## Breaking Changes Handled

### ✅ Removed Resources Migrated

**1. azurerm_sql_server → azurerm_mssql_server**
- **Files Modified:** `terraform/sql.tf`, `terraform/outputs.tf`
- **Changes Applied:**
  - Updated resource type from `azurerm_sql_server` to `azurerm_mssql_server`
  - Added `moved` block for automatic state migration
  - All arguments remain compatible (no argument changes required)
- **Argument Mappings:** No changes - schema is fully compatible
- **Default Values:** No breaking default value changes detected
- **Documentation:** [azurerm_mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server)

**2. azurerm_sql_database → azurerm_mssql_database**
- **Files Modified:** `terraform/sql.tf`, `terraform/outputs.tf`
- **Changes Applied:**
  - Updated resource type from `azurerm_sql_database` to `azurerm_mssql_database`
  - Replaced argument references:
    - Removed `resource_group_name` (no longer required)
    - Removed `location` (no longer required)
    - Changed `server_name` → `server_id` (now uses resource ID reference)
    - Changed `edition` + `requested_service_objective_name` → `sku_name` (unified SKU naming)
  - Added `moved` block for automatic state migration
- **Argument Mappings:**
  - `server_name = azurerm_sql_server.example.name` → `server_id = azurerm_mssql_server.example.id`
  - `edition = "Basic"` + `requested_service_objective_name = "Basic"` → `sku_name = "Basic"`
  - `resource_group_name` (removed - inherited from server)
  - `location` (removed - inherited from server)
- **Default Values:** No breaking default value changes detected
- **Documentation:** [azurerm_mssql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)

**3. azurerm_sql_firewall_rule → azurerm_mssql_firewall_rule**
- **Files Modified:** `terraform/sql.tf`
- **Changes Applied:**
  - Updated resource type from `azurerm_sql_firewall_rule` to `azurerm_mssql_firewall_rule`
  - Replaced argument references:
    - Removed `resource_group_name` (no longer required)
    - Changed `server_name` → `server_id` (now uses resource ID reference)
  - Added `moved` block for automatic state migration
- **Argument Mappings:**
  - `resource_group_name` (removed - no longer required)
  - `server_name = azurerm_sql_server.example.name` → `server_id = azurerm_mssql_server.example.id`
- **Default Values:** No breaking default value changes detected
- **Documentation:** [azurerm_mssql_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule)

**State Migration:** Terraform will automatically migrate state using `moved` blocks on next plan/apply. No manual `terraform state mv` commands required.

## Deprecations

**Deprecated Arguments/Resources Detected:**

1. **azurerm_sql_server** (resource) - Status: `applied`
   - Location: `terraform/sql.tf`
   - Replacement: `azurerm_mssql_server`
   - Reason: Resource removed in AzureRM v4.0, superseded by `azurerm_mssql_server`

2. **azurerm_sql_database** (resource) - Status: `applied`
   - Location: `terraform/sql.tf`
   - Replacement: `azurerm_mssql_database`
   - Reason: Resource removed in AzureRM v4.0, superseded by `azurerm_mssql_database`

3. **azurerm_sql_firewall_rule** (resource) - Status: `applied`
   - Location: `terraform/sql.tf`
   - Replacement: `azurerm_mssql_firewall_rule`
   - Reason: Resource removed in AzureRM v4.0, superseded by `azurerm_mssql_firewall_rule`

## Additional AzureRM v4.0 Changes

While not applicable to this repository, be aware of these major v4.0 changes:

- **Resource Provider Registration:** New `resource_provider_registrations` configuration (replaces `skip_provider_registration`)
- **Subscription ID Required:** Must now explicitly specify subscription ID
- **AKS API Migration:** AKS resources migrated to stable APIs (preview features removed)
- **Many deprecated resources removed:** Media Services, MariaDB, MySQL Single Server, IoT Time Series Insights, and others

See the [4.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide) for complete details.

## Next Steps

1. **Commit these changes** to the `terraform/upgrade-azurerm-provider-v4.63.0` branch
2. **Push the branch** and create a pull request
3. **Run your Terraform workflow** via CI/CD pipeline to validate changes
4. **Review plan output** to confirm:
   - State migrations are detected (moved blocks working)
   - No unexpected resource replacements
   - All resource attributes maintained
5. **Apply via pipeline** once plan is validated
6. **Merge pull request** after successful apply

## References

- [AzureRM Provider 4.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide)
- [AzureRM Provider v4.63.0 Release Notes](https://github.com/hashicorp/terraform-provider-azurerm/releases/tag/v4.63.0)
- [Terraform Moved Blocks Documentation](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring)
- [azurerm_mssql_server Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server)
- [azurerm_mssql_database Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)
- [azurerm_mssql_firewall_rule Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule)
- [Random Provider v3.8.1 Release Notes](https://github.com/hashicorp/terraform-provider-random/releases/tag/v3.8.1)
