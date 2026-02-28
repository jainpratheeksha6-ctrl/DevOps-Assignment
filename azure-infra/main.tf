# Non-Prod Resource Group
resource "azurerm_resource_group" "rg_nonprod" {
  count    = var.environment == "prod" ? 0 : 1
  name     = "${var.app_name}-${var.environment}-rg"
  location = var.location
}

# Prod Resource Group (Protected)
resource "azurerm_resource_group" "rg_prod" {
  count    = var.environment == "prod" ? 1 : 0
  name     = "${var.app_name}-${var.environment}-rg"
  location = var.location

  lifecycle {
    prevent_destroy = true
  }
}

locals {
  resource_group_name = var.environment == "prod" ? azurerm_resource_group.rg_prod[0].name : azurerm_resource_group.rg_nonprod[0].name
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.app_name}${var.environment}acr"
  resource_group_name = local.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.app_name}-${var.environment}-plan"
  location            = var.location
  resource_group_name = local.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.app_name}-${var.environment}-app"
  location            = var.location
  resource_group_name = local.resource_group_name
  service_plan_id     = azurerm_service_plan.asp.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      docker_image_name   = "backend-app:latest"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }

    container_registry_use_managed_identity = true
  }

  app_settings = {
    WEBSITES_PORT = "8000"
  }
}

data "azurerm_linux_web_app" "app_identity" {
  name                = azurerm_linux_web_app.app.name
  resource_group_name = local.resource_group_name

  depends_on = [
    azurerm_linux_web_app.app
  ]
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_linux_web_app.app_identity.identity[0].principal_id
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "${var.app_name}-${var.environment}-autoscale"
  resource_group_name = local.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.asp.id

  profile {
    name = "default"

    capacity {
      default = var.instance_count
      minimum = 1
      maximum = 3
    }
  }
}