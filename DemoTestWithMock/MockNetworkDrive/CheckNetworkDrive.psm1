function Test-NetworkDrive {
    param (
        [string]$FilePath
    )
    if( $FilePath -notmatch '^[\\]') {
        return $false
    }
    Test-Path -Path $FilePath
}

Export-ModuleMember -Function Test-NetworkDrive
