variable "rg_name" {
  description = "The Azure Resource Group used by the infrastructure"
  type        = string
}

variable "location" {
  description = "The Azure location the resources are located in"
  type        = string
  default     = "uksouth"
}

variable "vnet_name" {
  description = "The name of the vnet we will create"
  type        = string
}

variable "vnet_ip_address" {
  description = "The ip address for the vnet we create"
  type        = list(string)
}

variable "subnet_name_vh_agent" {
  description = "The name of the vnet we will create"
  type        = string
}

variable "subnet_name_vh_agent_address" {
  description = "The address of the ado agent on the subnet"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the keyvault we will create"
  type        = string
}


variable "vm_name" {
  description = "The name of the VM we create for the agent"
  type        = string
}

variable "vm_private_ip_address" {
  description = "The private ip address of the vm"
  type        = string
}

variable "vm_username" {
  description = "The username to login to the vm"
  type        = string
}

variable "vm_osdisk_name" {
  description = "The name of the vm os disk"
  type        = string
}

variable "nsg_name" {
  description = "Name for the network security group"
  type        = string
}

variable "env" {
  description = "name of environment for tagging"
  type        = string
}

variable "peer_client_id" {
  description = "client id of peering spn"
  type        = string
  sensitive   = true
}

variable "peer_client_secret" {
  description = "client secret of peering spn"
  type        = string
  sensitive   = true
}

variable "peer_tenant_id" {
  description = "tenant id of peering spn"
  type        = string
  sensitive   = true
}