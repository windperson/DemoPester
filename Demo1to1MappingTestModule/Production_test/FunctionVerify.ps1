
function VerifyParameters($commandInfo, $designedParamters) {
    # Note: since PowerShell's built-in Hashtable is case insensitive, we can't use it to exactly check function parameters
    $parameterTable = New-Object 'System.Collections.Hashtable'
    foreach ($key in $designedParamters.Keys) {
        $parameterTable.Add($key, $designedParamters[$key])
    }
    
    foreach ($parameter in $commandInfo.Parameters.Values.GetEnumerator()) {
        $parameterName = $parameter.Name
        $parameterTable.ContainsKey($parameterName) | Should -Be $true
        $parameterType = $parameter.ParameterType.FullName
        $parameterType | Should -Be $parameterType
    }
}