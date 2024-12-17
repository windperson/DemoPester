#Requires -Version 5.1
param(
    [string]$Source,
    [string]$Destination
)

# original code from this blog: https://www.meziantou.net/stop-the-script-when-an-error-occurs-in-powershell.htm
# Stop the script when a cmdlet or a native command fails
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
$scriptBlock = {
    # Disable $PSNativeCommandUseErrorActionPreference for this scriptblock only
    $PSNativeCommandUseErrorActionPreference = $false
    robocopy.exe $source $destination
    if ($LASTEXITCODE -gt 8) {
        throw "robocopy failed with exit code $LASTEXITCODE"
    }
}
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $Source, $Destination