output "resource_group_name" {
  description = "Azure Resource Group name"
  value       = local.resource_group_name
}

output "container_registry_login_server" {
  description = "ACR login server"
  value       = azurerm_container_registry.acr.login_server
}

output "container_registry_id" {
  description = "ACR ID"
  value       = azurerm_container_registry.acr.id
}

output "app_service_url" {
  description = "App Service URL"
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "app_service_name" {
  description = "App Service name"
  value       = azurerm_linux_web_app.app.name
}

output "service_plan_id" {
  description = "App Service Plan ID"
  value       = azurerm_service_plan.asp.id
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "location" {
  description = "Azure location"
  value       = var.location
}

output "instance_count" {
  description = "Instance count"
  value       = var.instance_count
}
