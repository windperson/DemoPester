function Show-Message {
    param (
        [string] $Message
    )

    Write-Output $Message
}

function Show-MessageWithPrefix {
    param (
        [string] $Message,
        [string] $Prefix
    )

    Write-Output "${Prefix}: $Message"
}
