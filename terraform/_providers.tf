provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "current_peering"
  subscription_id = data.azurerm_client_config.current.subscription_id
  client_id       = var.peering_client_id
  client_secret   = var.peering_client_secret
  tenant_id       = data.azurerm_client_config.current.tenant_id
}

provider "azurerm" {
  features {}
  alias           = "prod_peering"
  subscription_id = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
  client_id       = var.peering_client_id
  client_secret   = var.peering_client_secret
  tenant_id       = data.azurerm_client_config.current.tenant_id
}

provider "azurerm" {
  features {}
  alias           = "nonprod_peering"
  subscription_id = "fb084706-583f-4c9a-bdab-949aac66ba5c"
  client_id       = var.peering_client_id
  client_secret   = var.peering_client_secret
  tenant_id       = data.azurerm_client_config.current.tenant_id
}

provider "azurerm" {
  features {}
  alias           = "sbox_peering"
  subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
  client_id       = var.peering_client_id
  client_secret   = var.peering_client_secret
  tenant_id       = data.azurerm_client_config.current.tenant_id
}

provider "azurerm" {
  features {}
  alias           = "mgmt_peering"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  client_id       = var.peering_client_id
  client_secret   = var.peering_client_secret
  tenant_id       = data.azurerm_client_config.current.tenant_id
}