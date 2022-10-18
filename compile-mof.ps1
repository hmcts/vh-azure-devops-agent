
#Set global error action
$ErrorActionPreference = 'Stop'

#Delete Pre-existing MOFS in our DSC base folder
Get-ChildItem "$PSScriptRoot\dsc" -Recurse -Include '*.mof' | Remove-Item -Force
Get-ChildItem "$PSScriptRoot\dsc" -Recurse -Include '*.mof.error' | Remove-Item -Force

#Build MOFS
$DSCFiles = Get-ChildItem "$PSScriptRoot\dsc" -Recurse -Include '*.ps1'

foreach ($eachConfiguration in $DSCFiles) {
    Write-Output "Building MOFS: $eachConfiguration"
    .$eachConfiguration
}
      
$MOFb16 = Get-ChildItem "$PSScriptRoot\dsc" -Recurse -Include '*.mof'
mkdir "$PSScriptRoot\dsc\mof\" -Force

foreach ($MOF in $MOFb16) {
    Write-Output "Converting MOFS: $MOF"
    Get-Content $MOF | Set-Content -Encoding utf8 "$PSScriptRoot\dsc\mof\$($MOF.Name)"
}

Get-ChildItem "$PSScriptRoot\dsc\mof\"
