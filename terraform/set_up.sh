#!/bin/sh

# Create directory & download agent files
AZP_AGENT_VERSION=2.194.0
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
  --token "o2irf5uumopebjm6g7ohxcyaprufklijdnyv5hssgie66faraw2q" \
  --pool "vh-self-hosted" \
  --replace \
  --acceptTeeEula & wait $!"

cd /home/vhadoagent/
#Configure as a service
./svc.sh install vhadoagent

#Start svc
./svc.sh start