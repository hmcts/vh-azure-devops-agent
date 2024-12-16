# Create Resource Group
rg_name = "vh-infra-ado-stg-rg"

# Create Virtual Network
vnet_name                    = "vh-infra-ado-stg-vnet"
vnet_ip_address              = ["10.10.52.0/24"]
subnet_name_vh_agent         = "vh-infra-ado-stg-snet"
subnet_name_vh_agent_address = ["10.10.52.0/27"]

# Key Vault
key_vault_name = "vh-infra-ado-stg-kv"

# Create Virtual Machine
vm_username = "adoagent"

# Network Security Group
nsg_name = "vh-infra-ado-stg-nsg"

dns_zone = ["dev.platform.hmcts.net", "test.platform.hmcts.net", "ithc.platform.hmcts.net", "staging.platform.hmcts.net", "platform.hmcts.net", "demo.platform.hmcts.net"]

# route table
rt_name = "vh-infra-ado-stg-rt"

# vmss
vmss_name = "vh-infra-ado-stg-vmss"

# service endpoints
service_endpoints = [
  "Microsoft.Storage"
]
