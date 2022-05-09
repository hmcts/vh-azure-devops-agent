# Create Resource Group
rg_name = "vh-devops-agent-rg"

# Create Virtual Network
vnet_name                    = "vh-devops-agent-vnet"
vnet_ip_address              = ["192.162.0.0/16"]
subnet_name_vh_agent         = "vh-agent-subnet"
subnet_name_vh_agent_address = "192.162.0.0/24"

# Key Vault
key_vault_name = "vh-devops-agent-kv"

# Create Virtual Machine
vm_name               = "vh-devops-agent"
vm_private_ip_address = "192.162.0.4"
vm_pip_name           = "vh-devops-agent-pip"
vm_username           = "vhadoagent"
vm_osdisk_name        = "vh-devops-vm-osdisk"

# Network Security Group
nsg_name = "vh-devops-vm-nsg"