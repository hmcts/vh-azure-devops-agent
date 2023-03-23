# Create Resource Group
rg_name = "vh-infra-ado-dev-rg"

# Environment for Tagging
environment = "development"

# Create Virtual Network
vnet_name                    = "vh-infra-ado-dev-vnet-00"
vnet_ip_address              = ["10.221.143.0/24"]
subnet_name_vh_agent         = "vh-infra-ado-dev-snet-00"
subnet_name_vh_agent_address = ["10.221.143.0/28"]

# Key Vault
key_vault_name = "vh-infra-ado-dev-kv"

# Create Virtual Machine
vm_username = "adoagent"

# Network Security Group
nsg_name = "vh-infra-ado-dev-nsg"

dns_zone = []

dns_zone_sandbox = []

# route table
rt_name = "vh-infra-ado-dev-rt"

route_table = {
  route = [
    {
      name                   = "ss_dev_vnet"
      address_prefix         = "10.145.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    }
  ]
}

vmss_name = "vh-infra-ado-dev-vmss"