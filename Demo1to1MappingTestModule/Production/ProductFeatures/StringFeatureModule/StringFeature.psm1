<#
    .SYNOPSIS
    This function concatenates two strings.
#>
function Invoke-Cancatenate {
    param (
        [string]$a,
        [string]$b
    )

    $a + $b
}

<#
    .SYNOPSIS
    This function reverses a string.
#>
function Invoke-Reverse {
    param (
        [string]$aString
    )

    # Convert the string to a character array, reverse it, and join it back into a string
    $sourceCharArray = $aString.ToCharArray()
    [System.Array]::Reverse($sourceCharArray)
    return -join $sourceCharArray 
}

Export-ModuleMember -Function Invoke-Cancatenate
Export-ModuleMember -Function Invoke-Reverse