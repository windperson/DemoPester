<#
    .SYNOPSIS
    This function concatenates two strings.
#>
function Invoke-Concatenate {
    [OutputType([string])]
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
    [OutputType([string])]
    param (
        [string]$aString
    )

    # Convert the string to a character array, reverse it, and join it back into a string
    $sourceCharArray = $aString.ToCharArray()
    [System.Array]::Reverse($sourceCharArray)
    return -join $sourceCharArray
}

$script:PrefixStr = "DemoPrefix"

function Invoke-FixedPrefix {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSProvideCommentHelp', '')]
    [OutputType([string])]
    param (
        [string]$aString
    )

    process{
        return "$script:PrefixStr${aString}"
    }
}

Export-ModuleMember -Function Invoke-Concatenate
Export-ModuleMember -Function Invoke-Reverse
Export-ModuleMember -Function Invoke-FixedPrefix