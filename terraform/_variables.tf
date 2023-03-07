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

variable "vm_username" {
  description = "The username to login to the vm"
  type        = string
}

variable "vm_count" {
  description = "Count of how many VMs to create"
  type        = number
  default     = 1
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
  default     = ""
}

variable "peer_client_secret" {
  description = "client secret of peering spn"
  type        = string
  sensitive   = true
  default     = ""
}

variable "peer_tenant_id" {
  description = "tenant id of peering spn"
  type        = string
  sensitive   = true
  default     = ""
}
variable "dns_zone" {
  description = "private dns zone name"
  default     = {}
}
variable "dns_zone_sandbox" {
  description = "private dns zone name"
  default     = {}
}

variable "rt_name" {
  description = "The name of the RT we create for the agent"
  type        = string
}
variable "route_table" {
  description = "The RT we create for the agent"
  default     = {}
}

variable "compute_gallery_name" {
  description = "name given to Azure Compute Gallery"
  type        = string
}