# Create Resource Group
rg_name = "vh-infra-core-ado"

# Create Virtual Network
vnet_name                    = "vh-infra-core-ado"
vnet_ip_address              = ["192.162.0.0/16"]
subnet_name_vh_agent         = "vh-infra-core-ado-snet"
subnet_name_vh_agent_address = "192.162.0.0/24"

# Key Vault
key_vault_name = "vh-infra-core-ado"

# Create Virtual Machine
vm_name               = "vh-ado-agent-01"
vm_private_ip_address = "192.162.0.4"
vm_username           = "vhadoagent"
vm_osdisk_name        = "vh-ado-agent-01_OsDisk"

# Network Security Group
nsg_name = "vh-infra-core-ado-nsg"

# environment
env = "stg"