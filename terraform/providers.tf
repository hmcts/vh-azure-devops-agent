terraform {

  backend "azurerm" {}

  # provider "azurerm" {
  #   version = "~>2.0"
  #   features {}
  # }

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