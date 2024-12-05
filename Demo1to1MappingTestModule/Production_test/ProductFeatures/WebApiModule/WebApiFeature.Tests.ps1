#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion
BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

Describe "Web API function API declaration" -Tag "WebApiFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
        $ApiDefinition = @(
            @{
                Name        = 'Get-HttpGetResponse'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    apiUrl      = [string]
                    headers     = [hashtable]
                    httpVersion = [string]
                }
            }
        )
    }
    BeforeAll {
        . (Resolve-Path $UtiltiyModulePath\VerifyPsDefApi.ps1)
    }

    It "Should have API `'<Name>`' defined in ApiDefinition" -ForEach $ApiDefinition {
        VerifyApiDefinition -Name $Name -CommandType $CommandType
    }
}

Describe "Get-ApiData" -Tag "WebApiFeature" {
    Context "When calling the Web API" {
        It "Should return the response" {
            # Mock the Invoke-RestMethod cmdlet,
            # Since the testing function is imported as a global function in the ".ps1" script,
            # We don't need to specify the module name in the Mock command
            Mock -CommandName Invoke-RestMethod -MockWith {
                return @{ key = "value" }
            }

            # Define test parameters
            $apiUrl = "https://api.example.com/data"
            $headers = @{
                "Authorization" = "Bearer TEST_ACCESS_TOKEN"
                "Content-Type"  = "application/json"
            }

            # Call the function
            $result = Get-HttpGetResponse -apiUrl $apiUrl -headers $headers

            # Assert the result
            $result | Should -Not -BeNullOrEmpty
            $result.key | Should -Be "value"
        }
    }
}