variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ghawupgrade"
}

variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Additional tags to merge with defaults"
  type        = map(string)
  default     = {}
}

variable "sql_administrator_login" {
  description = "Administrator username for the SQL Server"
  type        = string
  default     = "sqladmin"
}
