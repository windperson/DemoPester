param(
    [string] $TestScriptPath,
    [string] $PsFileExtension = 'psm1',
    [System.Management.Automation.ActionPreference] $Verbose = 'SilentlyContinue'
)

# Replace '_test' with an empty string
$targetModuleFilePath = $TestScriptPath -replace '_test', ''

# Replace '.Tests.ps1' with '.psm1'
$targetModuleFilePath = $targetModuleFilePath -replace '\.Tests\.ps1$', ".$PsfileExtension"
Import-Module $targetModuleFilePath -Force -Verbose:$Verbose