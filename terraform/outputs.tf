output "app_service_url" {
  value = azurerm_app_service.app_service.default_site_hostname
}
