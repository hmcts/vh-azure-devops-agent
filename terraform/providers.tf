terraform {

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "current_sub_peer"
  subscription_id = data.azurerm_client_config.current.subscription_id
  client_id       = var.peer_client_id
  client_secret   = var.peer_client_secret
  tenant_id       = var.peer_tenant_id
}

provider "azurerm" {
  features {}
  alias           = "nonprod_peer"
  subscription_id = "fb084706-583f-4c9a-bdab-949aac66ba5c"
  client_id       = var.peer_client_id
  client_secret   = var.peer_client_secret
  tenant_id       = var.peer_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "mgmt_peer"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  client_id       = var.peer_client_id
  client_secret   = var.peer_client_secret
  tenant_id       = var.peer_tenant_id
}

provider "azurerm" {
  features {}
  alias           = "prod_peer"
  subscription_id = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
  client_id       = var.peer_client_id
  client_secret   = var.peer_client_secret
  tenant_id       = var.peer_tenant_id
}

provider "azurerm" {
  features {}
  alias           = "sbox_peer"
  subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
  client_id       = var.peer_client_id
  client_secret   = var.peer_client_secret
  tenant_id       = var.peer_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "core_infra_dns"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}
provider "azurerm" {
  features {}
  alias           = "sandbox_dns"
  subscription_id = "1497c3d7-ab6d-4bb7-8a10-b51d03189ee3"
  client_id       = var.peer_client_id
  client_secret   = var.peer_client_secret
  tenant_id       = var.peer_tenant_id
}
provider "azurerm" {
  features {}
  alias           = "reform_dns"
  subscription_id = "705b2731-0e0b-4df7-8630-95f157f0a347"
  client_id       = var.peer_client_id
  client_secret   = var.peer_client_secret
  tenant_id       = var.peer_tenant_id
}