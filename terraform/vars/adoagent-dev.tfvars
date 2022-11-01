# Create Resource Group
rg_name = "vh-infra-ado-dev"

# Create Virtual Network
vnet_name                    = "vh-infra-ado-dev"
vnet_ip_address              = ["10.10.52.0/24"]
subnet_name_vh_agent         = "vh-infra-core-ado-snet"
subnet_name_vh_agent_address = "10.10.52.0/27"

# Key Vault
key_vault_name = "vh-infra-ado-dev"

# Create Virtual Machine
vm_username = "vhadoagent"

# Network Security Group
nsg_name = "vh-infra-ado-dev-nsg"

dns_zone = []

dns_zone_sandbox = []

# route table
rt_name = "vh-infra-ado-dev-rt-01"

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
