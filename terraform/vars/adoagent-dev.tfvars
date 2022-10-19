# Create Resource Group
rg_name = "vh-infra-core-ado"

# Create Virtual Network
vnet_name                    = "vh-infra-core-ado"
vnet_ip_address              = ["10.10.52.0/24"]
subnet_name_vh_agent         = "vh-infra-core-ado-snet"
subnet_name_vh_agent_address = "10.10.52.0/27"

# Key Vault
key_vault_name = "vh-infra-dev-ado"

# Create Virtual Machine
vm_username = "vhadoagent"

# Network Security Group
nsg_name = "vh-infra-core-ado-nsg"

dns_zone = []

dns_zone_sandbox = []

# route table
rt_name = "vh-ado-agent-rt-01"

route_table = {
  route = [
    {
      name                   = "Route-01"
      address_prefix         = "10.10.52.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.8.36"
    }
  ]
}
