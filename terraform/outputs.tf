output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "db_fqdn" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "dns_zone_name" {
  value = azurerm_private_dns_zone.internal_dns.name
}

output "aks_kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

