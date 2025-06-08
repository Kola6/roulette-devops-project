output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "db_password" {
  value     = random_password.db.result
  sensitive = true
}

output "dns_zone_name" {
  value = azurerm_private_dns_zone.internal_dns.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

