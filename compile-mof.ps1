#Set global error action
$ErrorActionPreference = 'Stop'

function Install-LocalModules {
    param (
        $modules
        )
        foreach ($module in $modules) {
            Write-Output "Installing module: $module"
            Install-Module -Name $module
        }
    }

function ConvertTo-MOF {
    param (
        $file,
        $outputDir,
        $params
    )
    Write-Output "Building MOFS: $file"
    if ($params) {
        Write-Output "With params"
        $list = ""
        foreach ($param in $params.PSObject.Properties) {
            $list = "$list -$($param.Name) $($param.Value)"
        }
        .$file $list
    } else {
        Write-Output "Without params"
        .$file
    }
    Write-Output "Converting MOFS: $file"
    Get-Content $file | Set-Content -Encoding utf8 "$outputDir\$($file.Name)"
}

# Get configs
$configs = Get-Content "./dsc/configs.json" | ConvertFrom-Json
$tfPath = "$PSScriptRoot\terraform"
$dscPath = "$PSScriptRoot\dsc"

#Delete Pre-existing MOFS in our DSC base folder
Get-ChildItem dscPath -Recurse -Include '*.mof' | Remove-Item -Force
Get-ChildItem dscPath -Recurse -Include '*.mof.error' | Remove-Item -Force

#Loop over each config
foreach($obj in $configs.Configs.PSObject.Properties) {
        $file = $obj.Value.file
        $modules = $obj.Value.modules
        $name = $obj.Name
        $params = $obj.Value.params
        
        Write-Output "Processing $name"
        Install-LocalModules -modules $modules
        ConvertTo-MOF -file "$dscPath\$file" -params $params -outputDir $tfPath

}
