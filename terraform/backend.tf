terraform {
  backend "azurerm" {
    resource_group_name  = "roulette-dev-rg"
    storage_account_name = "roulettestorage"
    container_name       = "tfstate"
    key                  = "roulette.tfstate"
  }
}

