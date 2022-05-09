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

# # Install .NET Core SDK
sdk_version=3.1.416 \
    && curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$sdk_version/dotnet-sdk-$sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='dec1dcf326487031c45dec0849a046a0d034d6cbb43ab591da6d94c2faf72da8e31deeaf4d2165049181546d5296bb874a039ccc2f618cf95e68a26399da5e7f' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && dotnet help

echo "Installed .NET Core SDK 3.1.416"

# # Install .NET Core SDK
# https://download.visualstudio.microsoft.com/download/pr/9d8c7137-2091-4fc6-a419-60ba59c8b9de/db0c5cda94f31d2260d369123de32d59/dotnet-sdk-6.0.202-linux-x64.tar.gz
# mkdir -p $HOME/dotnet && tar zxf dotnet-sdk-6.0.202-linux-arm.tar.gz -C $HOME/dotnet
# && dotnet_sha512='e60f14841f1d0156de163f6f1e4c6358f14bd57e81beed13d294022da8a5182e41b8333591f92c4cac8eec138b7bc85725c19ae10e4e73a139a5231bb12b557f'
# export DOTNET_ROOT=$HOME/dotnet
# export PATH=$PATH:$HOME/dotnet
echo "Add the Microsoft package signing key" 
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
echo "Install dotnet version 6.0.202 using package manager"
sudo apt-get update; \
sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y dotnet-sdk-6.0
echo |"Finished installing dotnet version 6"


# # Install PowerShell global tool
powershell_version=7.0.8 \
    && curl -fSL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
    && powershell_sha512='2ad4d9d26af9bc5a0cd25b0dff2d7360a43a9f3bb29a7b9f4b27474f3897258dcc9b3bf6839b7f401cda2feefbc8f4ded2b15edb5ebf613b4ab26147dd9a330b' \
    && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.x64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm

echo "Installed PowerShell global tool"

# #Start svc
sudo /myagent/svc.sh start
sudo /myagent/svc.sh status