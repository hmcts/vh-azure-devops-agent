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

# Install .NET CLI dependencies
apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        tzdata \
        curl \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu60 \
        libssl1.1 \
        libstdc++6 \
        zlib1g \
      ; \
      rm -rf /var/lib/apt/lists/*

echo "Installed .NET CLI dependencies"