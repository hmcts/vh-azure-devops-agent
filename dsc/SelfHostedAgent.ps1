Configuration SelfHostedAgent
{
    ######################################################
    # DSC Preparation.
    ######################################################
    param
    (
        [parameter(mandatory=$true)]
        [string]$azureDevOpsPAT,

        [parameter(mandatory=$true)]
        [int32]$numberOfAgents,

        [parameter(mandatory=$true)]
        [string]$azureDevOpsURL
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'cChoco'

    ######################################################
    # Mount Data Disk.
    ######################################################
    Script MountDisk
    {
        TestScript = {
            Test-Path -Path "F:\"
        }

        SetScript = {
            $disks = Get-Disk | Where-Object partitionstyle -eq 'raw' | Sort-Object Number

            $letters = 70..89 | ForEach-Object { [char]$_ }
            $count = 0
            $label = "Data"
        
            foreach ($disk in $disks) {
                $driveLetter = $letters[$count].ToString()
                $disk |
                Initialize-Disk -PartitionStyle MBR -PassThru |
                New-Partition -UseMaximumSize -DriveLetter $driveLetter |
                Format-Volume -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false -Force
                $count++
            }
        }

        GetScript = {
            if (Test-Path -Path "F:\") {
                @{ Result = "F:\ IS Mounted." }
            }
            else {
                @{ Result = "F:\ IS NOT Mounted." }
            }
        }
    }
    ######################################################
    # Set Up Directories for Agents & DevOps Agents.
    ######################################################
    File AzureDevOpsAgents
    {
        Type            = 'Directory'
        DestinationPath = 'F:\AzureDevOpsAgents'
        Ensure          = "Present"
        DependsOn       = '[Script]MountDisk' 
    }

    foreach ($agent in 1..$numberOfAgents) {
        File "AgentDirectory_0$agent"
        {
            Type            = 'Directory'
            DestinationPath = "F:\AzureDevOpsAgents\$(hostname)_agent-0$agent"
            Ensure          = "Present"
            DependsOn       = '[Script]MountDisk', '[File]AzureDevOpsAgents'
        }  

        Script "AzureDevOpsAgent-0$agent"
        {
            TestScript = {
                $agent         = $using:agent
                $agentName     = "$(hostname)_agent-0$agent"
                $serviceStatus = Get-Service -Name "vstsagent.hmcts.VH Self Hosted.$agentName" -ErrorAction SilentlyContinue

                if ($serviceStatus.Length -gt 0) {
                    return $true
                }
                else {
                    return $False
                }
            }
    
            SetScript = {
                ######################################
                # Prepare Vars. ######################
                ######################################
                $agent      = $using:agent
                $installDir = "F:\AzureDevOpsAgents\$(hostname)_agent-0$agent"
                $agentName  = "$(hostname)_agent-0$agent"
                $zipPath    = 'C:\Temp\agent.zip'

                ######################################
                # Download Agent. ####################
                ######################################
                New-Item -ItemType Directory -Force -Path 'C:\Temp'
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

                $latest = Invoke-WebRequest 'https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest' -UseBasicParsing
                $tag    = ($latest | ConvertFrom-Json)[0].tag_name.SubString(1)
                $url    = "https://vstsagentpackage.azureedge.net/agent/$tag/vsts-agent-win-x64-$tag.zip"

                 if (!(Test-Path -Path $zipPath)) {
                     Invoke-WebRequest $url -Out $zipPath -UseBasicParsing
                }
                
                ######################################
                # Install Agent. #####################
                ######################################
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $installDir)
                Set-Location -Path $installDir
                .\config.cmd --url $using:azureDevOpsURL --auth pat --token $using:AzureDevOpsPAT --pool 'VH Self Hosted' --agent $agentName --acceptTeeEula --runAsService --unattended
            }
    
            GetScript = {
                $agent         = $using:agent
                $agentName     = "$(hostname)_agent-0$agent"
                $serviceStatus = Get-Service -Name "vstsagent.hmcts.VH Self Hosted.$agentName" -ErrorAction SilentlyContinue

                if ($serviceStatus.Length -gt 0) {
                    @{ Result = "$agentName IS Installed." }
                }
                else {
                    @{ Result = "$agentName IS NOT Installed." }
                }
            }
        }
    }
    ######################################################
    # Choco Installers.
    ######################################################
    cChocoInstaller installChoco
    {
        InstallDir = 'C:\choco'
    }

    cChocoPackageInstaller AzureCLI
    {
        Name       = "azure-cli"
        Version    = "2.40.0"
        DependsOn  ='[cChocoInstaller]installChoco'
    }

    cChocoPackageInstaller dotnet6
    {
        Name      = "dotnet"
        Version   = "6.0.10"
        DependsON ='[cChocoInstaller]installChoco'
    }

    cChocoPackageInstaller dotnet3
    {
        Name      = "dotnet3.5"
        Version   = "3.5.20160716"
        DependsON ='[cChocoInstaller]installChoco'
    }

    cChocoPackageInstaller PowerShellCore
    {
        Name      = "powershell-core"
        Version   = "7.2.6"
        DependsON ='[cChocoInstaller]installChoco'
    }
    
    cChocoPackageInstaller Chrome
    {
        Name     = "googlechrome"
        Version  = "106.0.5249.119"
    }
}