provider "azurerm" {
  features {}
}

# RESOURCE GROUP
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# VIRTUAL NETWORK
resource "azurerm_virtual_network" "vnet" {
  name                = "roulette-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ACR
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

# AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_container_registry.acr]
}

# POSTGRESQL FLEXIBLE SERVER
resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "roulette-db"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "12"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = "B1ms"
  storage_mb             = 32768
}

resource "azurerm_postgresql_flexible_server_database" "roulette" {
  name      = "roulettegamedb"
  server_id = azurerm_postgresql_flexible_server.db.id
  charset   = "UTF8"
  collation = "English_United States.1252"
}

# PRIVATE DNS ZONE FOR INTERNAL ACCESS
resource "azurerm_private_dns_zone" "internal_dns" {
  name                = "internal.company.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "link-vnet"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.internal_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
}

