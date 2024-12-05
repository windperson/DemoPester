#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion
BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -Verbose:$VerbosePreference
}

#region Module definition tests
Describe "String function declaration" -Tag "StringFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
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
            @{
                Name    = 'Invoke-FixedPrefix'
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

    It "Should have API `'<Name>`' defined in ApiDefinition" -ForEach $ApiDefinition {
        VerifyApiDefinition -Name $Name -CommandType $CommandType
    }

}
#endregion

Describe "String function feature" -Tag "StringFeature" {
    Context "Invoke-Concatenate" {
        It "Should return 'ab' when 'a' and 'b' are passed" {
            Invoke-Concatenate -a 'a' -b 'b' | Should -Be 'ab'
        }
    }

    Context "Invoke-Reverse" {
        It "Should return 'cba' when 'abc' is passed" {
            Invoke-Reverse -aString 'abc' | Should -Be 'cba'
        }
    }
}

Describe "Prefix function feature" -Tag "StringFeature" {
    Context "Override script level varaible when test 'Invoke-FisedPrefix()' function" {
        It "should return string with mocked prefix" {
            InModuleScope StringFeature {
                # Demo Pester's InModuleScope feature to override $script level variable for single unit test case
                $script:PrefixStr = "MyPrefix "
            }
            Invoke-FixedPrefix -aString  'abc' | Should -Be 'MyPrefix abc'
        }
    }
}