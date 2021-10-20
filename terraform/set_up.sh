#!/bin/sh

# Create directory & download agent files

export AZP_AGENT_VERSION==$(curl -s https://api.github.com/repos/microsoft/azure-pipelines-agent/releases | jq -r '.[0].tag_name' | cut -d "v" -f 2)
su - vhadoagent -c "
sudo apt install jq -y
export AZP_AGENT_VERSION==$(curl -s https://api.github.com/repos/microsoft/azure-pipelines-agent/releases | jq -r '.[0].tag_name' | cut -d "v" -f 2)
mkdir myagent && cd myagent
wget https://vstsagentpackage.azureedge.net/agent/$AZP_AGENT_VERSION/vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz
tar zxvf vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz"

#Install

su - vhadoagent -c "
./config.sh --unattended \
  --agent "vh-devops-agent-self-hosted" \
  --url "https://hmctsreform.visualstudio.com" \
  --auth PAT \
  --token "<PAT_Token>" \
  --pool "vh-self-hosted" \
  --replace \
  --acceptTeeEula & wait $!"

cd /home/vhadoagent/
#Configure as a service
sudo ./svc.sh install vhadoagent

#Start svc
sudo ./svc.sh start