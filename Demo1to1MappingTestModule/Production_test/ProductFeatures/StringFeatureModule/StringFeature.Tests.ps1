BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -Verbose:$VerbosePreference
}

Describe "String function declaration" -Tag "StringFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        $ApiDefinition = @(
            @{
                Name    = 'Invoke-Concatenate'
                Inputs  = @{
                    a = [string]
                    b = [string]
                }
                Outputs = @([string])
            }
            @{
                Name    = 'Invoke-Reverse'
                Inputs  = @{
                    aString = [string]
                }
                Outputs = @([string])
            }
        )
    }
    BeforeAll {
        . (Resolve-Path $UtiltiyModulePath\VerifyPsDefApi.ps1) 
    }

    It "Should have APIs defined in ApiDefinition" -ForEach $ApiDefinition {
        VerifyApiDefinition -Name $Name -CommandType $CommandType
    }

}

Describe "String function feature" -Tag "StringFeature" {
    Context "Invoke-Cancatenate" {
        It "Should return 'ab' when 'a' and 'b' are passed" {
            Invoke-Concatenate -a 'a' -b 'b' | Should -Be 'ab'
        }
    }

    Context "Invoke-Reverse" {
        It "Should return 'cba' when 'abc' is passed" {
            Invoke-Reverse -a 'abc' | Should -Be 'cba'
        }
    }
}