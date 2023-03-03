resource "azurerm_shared_image_gallery" "vhinfracoreado" {
  name                = var.compute_gallery_name
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  description         = "Compute Gallery for VM Images"

  tags = local.common_tags
}

resource "azurerm_shared_image" "ubuntu22_ado_agent" {
  name                = "ubuntu22-ado-agent"
  gallery_name        = azurerm_shared_image_gallery.vhinfracoreado.name
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  os_type             = "Linux"
  hyper_v_generation  = "V2"

  identifier {
    publisher = "cannonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
  }

  tags = local.common_tags
}