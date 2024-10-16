param(
    [string] $TestScriptPath,
    [string] $PsFileExtension = 'psm1',
    [switch] $ImportModuleNameChecking = $false,
    [object[]] $ArgumentList = @(),
    [System.Management.Automation.ActionPreference] $Verbose = 'SilentlyContinue',
    [string] $TestScriptLocationPostfix = '_test',
    [string] $TestScriptNamePattern = '\.Tests\.ps1$'
)

# Replace '_test' with an empty string
$targetModuleFilePath = $TestScriptPath -replace $TestScriptLocationPostfix, ''

# Replace '.Tests.ps1' with '.psm1'
$targetModuleFilePath = $targetModuleFilePath -replace $TestScriptNamePattern, ".$PsfileExtension"
Import-Module $targetModuleFilePath -Force -DisableNameChecking:$(-not $ImportModuleNameChecking) -ArgumentList:$ArgumentList -Verbose:$Verbose