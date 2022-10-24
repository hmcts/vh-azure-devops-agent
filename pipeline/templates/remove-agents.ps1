param(
 [Parameter(Mandatory = $true)]
 [ValidateNotNullOrEmpty()]
 [string]$PAT,

 [Parameter(Mandatory = $true)]
 [string]$OrganizationName,

 [Parameter(Mandatory = $true)]
 [string]$AgentPoolName,

 [Parameter(Mandatory = $false)]
 [string]$ApiVersion = '5.1'
)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$EncodedPAT = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$PAT"))
$PoolsUrl = "https://dev.azure.com/$($OrganizationName)/_apis/distributedtask/pools?api-version=$($ApiVersion)"
try {
 $Pools = (Invoke-RestMethod -Uri $PoolsUrl -Method 'Get' -Headers @{Authorization = "Basic $EncodedPAT"}).value
} catch {
 throw $_.Exception
}

If ($Pools) {
 $PoolId = ($Pools | Where-Object { $_.Name -eq $AgentPoolName }).id
 $AgentsUrl = "https://dev.azure.com/$($OrganizationName)/_apis/distributedtask/pools/$($PoolId)/agents?api-version=$($ApiVersion)"
 $Agents = (Invoke-RestMethod -Uri $AgentsUrl -Method 'Get' -Headers @{Authorization = "Basic $EncodedPAT"}).value
 if ($Agents) {
   $AgentNames = $Agents.Name
   $devAgents = $Agents.id
   foreach ($devAgent in $devAgents) {
     foreach ($AgentName in $AgentNames) {
       Write-Output "Removing: $($AgentName) From Pool: $($AgentPoolName) in Organization: $($OrganizationName)"
       $devAgentsUrl = "https://dev.azure.com/$($OrganizationName)/_apis/distributedtask/pools/$($PoolId)/agents/$($devAgent)?api-version=$($ApiVersion)"
       Invoke-RestMethod -Uri $devAgentsUrl -Method 'Delete' -Headers @{Authorization = "Basic $EncodedPAT"}
     }
   }
 } else {
   Write-Output "No Agents found in $($AgentPoolName) for Organization $($OrganizationName)"
 }
} else {
 Write-Output "No Pools named $($AgentPoolName) found in Organization $($OrganizationName)"
}