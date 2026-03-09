# Terraform Provider Upgrade: AzureRM v3.75.0 → v4.63.0, Random v3.5.0 → v3.8.1

**Date:** 2026-03-09

## Summary

Upgraded HashiCorp AzureRM provider from v3.75.0 to v4.63.0 (major version upgrade) and Random provider from v3.5.0 to v3.8.1 (minor version). This major version upgrade for AzureRM included automatic migration of removed SQL resources to their modern MSSQL equivalents using `moved` blocks for seamless state migration.

## What Changed

- **Provider Versions:**
  - AzureRM: `~> 3.75.0` → `~> 4.63.0`
  - Random: `~> 3.5.0` → `~> 3.8.1`
- **Resource Migrations:** Migrated deprecated `azurerm_sql_*` resources to `azurerm_mssql_*` equivalents
- **Argument Updates:** Changed from name-based to ID-based references for firewall rules
- **State Migration:** Added `moved` blocks for automatic Terraform state migration

## Breaking Changes Handled

### ✅ 1. azurerm_sql_server → azurerm_mssql_server

**Files Modified:** `terraform/sql.tf`, `terraform/outputs.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_server` to `azurerm_mssql_server`
- Added `moved` block for automatic state migration
- All existing arguments remain compatible (no changes required)

**Argument Mappings:**
- ✅ `name` - Compatible (no change)
- ✅ `resource_group_name` - Compatible (no change)
- ✅ `location` - Compatible (no change)
- ✅ `version` - Compatible (no change)
- ✅ `administrator_login` - Compatible (no change)
- ✅ `administrator_login_password` - Compatible (no change)
- ✅ `identity` block - Compatible (no change)
- ✅ `tags` - Compatible (no change)

**Default Values:** No new default value changes affecting existing behavior.

**Documentation:** [azurerm_mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server)

---

### ✅ 2. azurerm_sql_database → azurerm_mssql_database

**Files Modified:** `terraform/sql.tf`, `terraform/outputs.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_database` to `azurerm_mssql_database`
- Removed deprecated arguments: `resource_group_name`, `location`, `edition`, `requested_service_objective_name`
- Changed `server_name` argument to `server_id` (now uses server ID reference)
- Changed `edition` + `requested_service_objective_name` to unified `sku_name` property
- Added `moved` block for automatic state migration

**Argument Mappings:**
- ✅ `name` → `name` (no change)
- ❌ `resource_group_name` (removed - inherited from server)
- ❌ `location` (removed - inherited from server)
- ✅ `server_name` → `server_id` (changed to ID reference: `azurerm_mssql_server.example.id`)
- ✅ `edition` + `requested_service_objective_name` → `sku_name` (combined into single property: `"Basic"`)
- ✅ `tags` → `tags` (no change)

**Default Values:** No new default value changes affecting existing behavior.

**Documentation:** [azurerm_mssql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)

---

### ✅ 3. azurerm_sql_firewall_rule → azurerm_mssql_firewall_rule

**Files Modified:** `terraform/sql.tf`

**Changes Applied:**
- Updated resource type from `azurerm_sql_firewall_rule` to `azurerm_mssql_firewall_rule`
- Removed deprecated arguments: `resource_group_name`, `server_name`
- Changed to use `server_id` (ID-based reference instead of name-based)
- Updated reference from `azurerm_sql_server.example.name` to `azurerm_mssql_server.example.id`
- Added `moved` block for automatic state migration

**Argument Mappings:**
- ✅ `name` → `name` (no change)
- ❌ `resource_group_name` (removed - inherited from server ID)
- ✅ `server_name` → `server_id` (changed to ID reference: `azurerm_mssql_server.example.id`)
- ✅ `start_ip_address` → `start_ip_address` (no change)
- ✅ `end_ip_address` → `end_ip_address` (no change)

**Default Values:** No new default value changes affecting existing behavior.

**Documentation:** [azurerm_mssql_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule)

---

## Deprecations

### ✅ Auto-Fixed Deprecations

**Deprecated SQL Resources (AzureRM 3.x)**
- **Found:** `azurerm_sql_server`, `azurerm_sql_database`, `azurerm_sql_firewall_rule` in `terraform/sql.tf`
- **Replacement:** `azurerm_mssql_server`, `azurerm_mssql_database`, `azurerm_mssql_firewall_rule`
- **Auto-fix Status:** ✅ Applied
- **Reason:** These resources were removed in AzureRM 4.x. Migration applied automatically with `moved` blocks for seamless state transition.

### Additional Deprecation Scan

**No other deprecated arguments/resources detected** in the codebase. All other resources use current, non-deprecated AzureRM provider features compatible with v4.x.

---

## State Migration Strategy

All resource type changes use Terraform `moved` blocks to ensure **automatic state migration** without manual intervention:

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

When you run `terraform plan`, Terraform will automatically:
1. Detect the state migration instructions
2. Move existing state entries to new resource types
3. Show updates in-place (not replacements)

**No manual `terraform state mv` commands required.**

---

## Next Steps

### 1. Review Changes
This pull request includes all necessary code changes for the upgrade. Review the modified files to understand the resource migrations.

### 2. Validate via CI/CD Pipeline
The Terraform workflow will automatically:
- Initialize with new provider versions
- Generate a plan showing state migrations
- Validate configurations with `terraform validate`

### 3. Expected Plan Output
When the pipeline runs `terraform plan`, you should see:
```
# azurerm_mssql_server.example has moved to azurerm_mssql_server.example
# azurerm_mssql_database.example has moved to azurerm_mssql_database.example
# azurerm_mssql_firewall_rule.azure_services has moved to azurerm_mssql_firewall_rule.azure_services
```

These will show as **updates in-place**, not replacements.

### 4. Monitor for Unexpected Changes
Verify the plan shows no unexpected resource replacements or deletions. The `moved` blocks ensure continuity of existing infrastructure.

### 5. Merge and Apply
Once validated, merge this PR. The next Terraform apply will:
- Download new provider versions
- Migrate state automatically
- Apply any necessary in-place updates

---

## AzureRM 4.x Major Changes (Not Affecting This Repository)

The following AzureRM 4.x breaking changes **do not affect** this repository:

- ✅ **Resource Provider Registration:** Provider block doesn't use deprecated `skip_provider_registration`
- ✅ **AKS API Changes:** No AKS resources in use
- ✅ **Removed Resources:** Only SQL resources affected (now migrated)
- ✅ **Deprecated Arguments:** No other deprecated arguments found in codebase
- ✅ **Default Value Changes:** Reviewed; no behavioral impacts detected

---

## References

- [AzureRM Provider 4.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide)
- [AzureRM v4.63.0 Release Notes](https://github.com/hashicorp/terraform-provider-azurerm/releases/tag/v4.63.0)
- [Random Provider v3.8.1 Release Notes](https://github.com/hashicorp/terraform-provider-random/releases/tag/v3.8.1)
- [Terraform Moved Blocks Documentation](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring)
- [azurerm_mssql_server Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server)
- [azurerm_mssql_database Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)
- [azurerm_mssql_firewall_rule Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule)
