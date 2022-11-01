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
vm_username = "vhadoagent"

# Network Security Group
nsg_name = "vh-infra-core-ado-nsg"

dns_zone = ["dev.platform.hmcts.net", "test.platform.hmcts.net", "ithc.platform.hmcts.net", "staging.platform.hmcts.net", "platform.hmcts.net", "demo.platform.hmcts.net"]

dns_zone_sandbox = ["sandbox.platform.hmcts.net"]

# route table
rt_name = "vh-ado-agent-rt-01"

route_table = {
  route = [
    {
      name                   = "ss_prod_vnet"
      address_prefix         = "10.144.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.8.36"
    },
    {
      name                   = "ss_stg_vnet"
      address_prefix         = "10.148.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.8.36"
    },
    {
      name                   = "ss_test_vnet"
      address_prefix         = "10.141.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    },
    {
      name                   = "ss_dev_vnet"
      address_prefix         = "10.145.0.0/18"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.11.72.36"
    } 
  ]
}
