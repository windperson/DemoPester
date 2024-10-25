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

    $Lines = (Get-Content -Path $filePath) -match "^(\s*$searchPattern\s*)`$"
    if ($null -eq $Lines -or $Lines.Length -eq 0 ) {
        Write-Output "No line(s) will be comment out on '$filePath' with search pattern '$searchPattern'"
    }
    else {
        Write-Output "$($Lines.Length) line(s) will be comment out on $filePath"
        $replaceStr = "$commentText`$1"
        if ($PSCmdlet.ShouldProcess($filePath, "Update some line with line comments")) {
            (Get-Content -Path $filePath) -replace "^(\s*$searchPattern\s*)`$", $replaceStr | Set-Content -Path $filePath -ErrorAction Stop -Confirm:$false
        }
    }
}