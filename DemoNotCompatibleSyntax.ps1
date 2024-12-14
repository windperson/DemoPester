### This script is for validating the compatibility of Windows PowerShell v5.1 with PowerShell v7.1 syntax,
### You can tweak your PSScriptAnalyzer settings to make it show warnings for Windows PowerShell v5.1 incompatible syntax.

$customObj = [PSCustomObject]@{
    Count     = 0
    Alphabets = @()
}

# Below are Windows PowerShell v5.1 incompatible syntax examples

$x = $null
$x ??= 100

$y = $x -gt 0 ? $x : 0
Write-Output "`$y=$y"

$z = ${customObj}?.Count
Write-Output "`$z=$z"

# In Windows PowerShell, you need to add explicit casting for non-number elements
$customObj.Alphabets = [char[]] [char]'A'..[char]'Z'

