function Set-FileLineComment {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$filePath,
        [string]$searchPattern,
        [string]$commentText = '#'
    )

    if (-not(Test-Path $filePath)) {
        throw "File not exist"
    }

    $replaceStr = "$commentText`$1"

    if ($PSCmdlet.ShouldProcess($filePath)) {
        (Get-Content -Path $filePath) -replace "^(\s*$searchPattern\s*)`$", $replaceStr | Set-Content -Path $filePath
    }
}