resource "azurerm_service_plan" "example" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = local.common_tags
}

resource "azurerm_linux_web_app" "example" {
  name                = local.linux_web_app_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    always_on = false

    application_stack {
      docker_image_name   = "mcr.microsoft.com/azuredocs/aci-helloworld"
      docker_registry_url = "https://mcr.microsoft.com"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITE_RUN_FROM_PACKAGE            = "0"
    ENVIRONMENT                         = var.environment
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}
