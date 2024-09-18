function Show-Message {
    [CmdletBinding()]
    param (
        [string] $Message
    )

    Write-Output $Message
}

function Show-MessageWithPrefix {
    [CmdletBinding()]
    param (
        [string] $Message,
        [string] $Prefix
    )

    Write-Output "${Prefix}: $Message"
}
