
function VerifyParameters {
    <#
    .SYNOPSIS
    Verify if the function parameters are designed correctly.
    #>
    param(
        [System.Management.Automation.CommandInfo]$commandInfo,
        [System.Collections.Hashtable]$designedParameters
    )
    # Note: since PowerShell's built-in Hashtable is case insensitive, we can't use it to exactly check function parameters
    $parameterTable = New-Object 'System.Collections.Hashtable'
    foreach ($key in $designedParameters.Keys) {
        $parameterTable.Add($key, $designedParameters[$key])
    }

    $cmdletBuiltInParameters = @('Verbose', 'Debug', 'ErrorAction', 'ErrorVariable', 'WarningAction', 'WarningVariable', 'OutBuffer', 'OutVariable', 'PipelineVariable')
    
    foreach ($parameter in $commandInfo.Parameters.Values.GetEnumerator()) {
        $parameterName = $parameter.Name
        if ( $commandInfo.CmdletBinding -and $cmdletBuiltInParameters -contains $parameterName) {
            continue
        }
        $parameterTable.ContainsKey($parameterName) | Should -Be $true -Because "Parameter '$parameterName' should be exist"
        $parameterType = $parameter.ParameterType.FullName
        $expectedType = $parameterTable[$parameterName]
        $parameterType | Should -Be $expectedType -Because "Parameter '$parameterName' should be of type '$expectedType'"
    }
}