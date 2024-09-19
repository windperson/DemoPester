function Show-Message {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [string] $Message
    )

    Write-Output $Message
}

function Show-MessageWithPrefix {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [string] $Message,
        [string] $Prefix
    )

    Write-Output "${Prefix}: $Message"
}

function Show-TimeStampedMessage {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [string] $Message
    )

    Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
}
