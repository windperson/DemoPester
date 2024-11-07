$script:name = "World"

function Get-Greeting {
    $greeting = "Hello, $script:name!"
    return $greeting
}

function Set-GreeterName {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param(
        [Parameter(Mandatory)]
        [string]
        $GreeterName
    )

    $script:name = $GreeterName
}