#!/bin/sh

# EXPORT the dotnet_cli_home and run as root
export DOTNET_CLI_HOME=/temp
export AGENT_ALLOW_RUNASROOT="1"

# Create directory & download agent files
AZP_AGENT_VERSION=2.202.1
su - vhadoagent -c "
mkdir ~/myagent && cd ~/myagent
wget https://vstsagentpackage.azureedge.net/agent/$AZP_AGENT_VERSION/vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz
ls -ltr
tar zxvf vsts-agent-linux-x64-$AZP_AGENT_VERSION.tar.gz"

#Install

su - vhadoagent -c "
~/myagent/config.sh --unattended \
  --agent "vh-devops-agent-selfhost-ENV" \
  --url "https://hmctsreform.visualstudio.com" \
  --auth PAT \
  --token REPLACE \
  --pool "vh-self-hosted" \
  --replace \
  --acceptTeeEula & wait $!"
echo "our exit value is $?"

cd /home/vhadoagent/
#Configure as a service
./svc.sh install vhadoagent

# # Install .NET CLI dependencies
# apt-get update \
#     && apt-get install -y --no-install-recommends \
#         ca-certificates \
#         tzdata \
#         curl \
#         libc6 \
#         libgcc1 \
#         libgssapi-krb5-2 \
#         libicu60 \
#         libssl1.1 \
#         libstdc++6 \
#         zlib1g \
#       ; \
#       rm -rf /var/lib/apt/lists/*

# echo "Installed .NET CLI dependencies"

# # Install .NET Core SDK
# sdk_version=3.1.416 \
#     && curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$sdk_version/dotnet-sdk-$sdk_version-linux-x64.tar.gz \
#     && dotnet_sha512='dec1dcf326487031c45dec0849a046a0d034d6cbb43ab591da6d94c2faf72da8e31deeaf4d2165049181546d5296bb874a039ccc2f618cf95e68a26399da5e7f' \
#     && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
#     && mkdir -p /usr/share/dotnet \
#     && tar -oxzf dotnet.tar.gz -C /usr/share/dotnet \
#     && rm dotnet.tar.gz \
#     && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
#     && dotnet help

# echo "Installed .NET Core SDK"

# # Install PowerShell global tool
# powershell_version=7.0.8 \
#     && curl -fSL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
#     && powershell_sha512='2ad4d9d26af9bc5a0cd25b0dff2d7360a43a9f3bb29a7b9f4b27474f3897258dcc9b3bf6839b7f401cda2feefbc8f4ded2b15edb5ebf613b4ab26147dd9a330b' \
#     && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
#     && mkdir -p /usr/share/powershell \
#     && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
#     && dotnet nuget locals all --clear \
#     && rm PowerShell.Linux.x64.$powershell_version.nupkg \
#     && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
#     && chmod 755 /usr/share/powershell/pwsh \
#     && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm

# echo "Installed PowerShell global tool"

#Start svc
./svc.sh start