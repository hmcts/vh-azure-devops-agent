variable "rg_name" {
  type = string
}

variable "RG_NAME" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "vnet_name" {
  type = string
}

variable "VNET_NAME" {
  type = string
}


variable "vnet_ip_address" {
  type = list(string)
}

variable "subnet_name_vh_agent" {
  type = string
}

variable "subnet_name_vh_agent_address" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "KV_NAME" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "VM_NAME" {
  type = string
}

variable "vm_private_ip_address" {
  type = string
}

variable "vm_pip_name" {
  type = string
}

variable "vm_username" {
  type = string
}

variable "vm_osdisk_name" {
  type = string
}

variable "nsg_name" {
  type = string
}

variable "NSG_NAME" {
  type = string
}
