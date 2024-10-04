using namespace System.Diagnostics.CodeAnalysis
[SuppressMessage('PSAvoidGlobalVars', '')]
param()
<#
    .SYNOPSIS
    This function adds two numbers together.

#>
function Invoke-Add {
    [OutputType([int])]
    param (
        [int]$a,
        [int]$b
    )

    $a + $b
}

<#
    .SYNOPSIS
    This function subtracts two numbers.
#>
function Invoke-Sub {
    [OutputType([int])]
    param (
        [int]$a,
        [int]$b
    )

    $a - $b
}

<#
    .SYNOPSIS
    This function multiplies two numbers.
#>
function Invoke-Mul {
    [OutputType([int])]
    param (
        [int]$a,
        [int]$b
    )

    $a * $b
}


<#
    .SYNOPSIS
    This function divides two numbers.
#>
function Invoke-Div {
    [OutputType([int])]
    param (
        [int]$a,
        [int]$b
    )

    $a / $b
}

$Global:Pi = [Math]::PI

function Calculate-Circumference {
    [SuppressMessage('PSUseApprovedVerbs', '')]
    [SuppressMessage('PSProvideCommentHelp', '')]
    [SuppressMessage('PSAvoidGlobalVars', '')]
    [OutputType([double])]
    param(
        [double] $radius
    )

    return 2 * $radius * $Global:PI
}

Export-ModuleMember -Function Invoke-Add
Export-ModuleMember -Function Invoke-Sub
Export-ModuleMember -Function Invoke-Mul
Export-ModuleMember -Function Invoke-Div
Export-ModuleMember -Function Calculate-Circumference