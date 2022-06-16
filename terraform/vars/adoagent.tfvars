# Create Resource Group
rg_name = "vh-infra-core-ado"

# Create Virtual Network
vnet_name                    = "vh-infra-core-ado"
vnet_ip_address              = ["10.10.52.0/24"]
subnet_name_vh_agent         = "vh-infra-core-ado-snet"
subnet_name_vh_agent_address = "10.10.52.0/27"

# Key Vault
key_vault_name = "vh-infra-core-ado"

# Create Virtual Machine
vm_name               = "vh-ado-agent-01"
vm_private_ip_address = "10.10.52.6"
vm_username           = "vhadoagent"
vm_osdisk_name        = "vh-ado-agent-01_OsDisk"

# Network Security Group
nsg_name = "vh-infra-core-ado-nsg"

# environment
env = "stg"

dns_zone = ["dev.platform.hmcts.net", "dev.platform.hmcts.net"]