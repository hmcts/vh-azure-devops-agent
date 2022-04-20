#!/bin/sh

# EXPORT the dotnet_cli_home and run as root
export DOTNET_CLI_HOME=/temp
export AGENT_ALLOW_RUNASROOT="1"

# Create directory & download agent files
AZP_AGENT_VERSION=2.202.1
su - vhadoagent -c "
mkdir myagent && cd myagent
wget https://vstsagentpackage.azureedge.net/agent/$AZP_AGENT_VERSION/vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz
ls -ltr
tar zxvf vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz"

#Install

su - vhadoagent -c "
~/myagent/config.sh --unattended \
  --agent "vh-devops-agent-self-hosted" \
  --url "https://hmctsreform.visualstudio.com" \
  --auth PAT \
  --token REPLACE \
  --pool "vh-self-hosted" \
  --replace \
  --acceptTeeEula & wait $!"

cd /home/vhadoagent/
#Configure as a service
sudo ./svc.sh install vhadoagent


#Start svc
sudo ./svc.sh start