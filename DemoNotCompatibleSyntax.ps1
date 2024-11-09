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

