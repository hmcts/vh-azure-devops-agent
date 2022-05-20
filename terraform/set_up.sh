#!/bin/sh

###

# Create directory & download agent files
AZP_AGENT_VERSION=2.202.1
sudo mkdir /myagent 
cd /myagent
sudo wget https://vstsagentpackage.azureedge.net/agent/$AZP_AGENT_VERSION/vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz
sudo tar zxvf ./vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz
sudo chmod -R 777 /myagent
#Install

sudo runuser -l vhadoagent -c "cd /myagent ; ./config.sh --unattended --url https://hmctsreform.visualstudio.com --auth pat --token REPLACE --pool vh-self-hosted --agent vh-devops-agent-self-hosted-PL --acceptTeeEula & wait $!"
sudo /myagent/svc.sh install
