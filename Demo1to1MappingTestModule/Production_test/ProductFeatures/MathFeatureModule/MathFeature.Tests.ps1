BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -Verbose:$VerbosePreference
}

Describe "Math function API declaration" -Tag "MathFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        $ApiDefinition = @(
            @{
                Name    = 'Invoke-Add'
                Inputs  = @{
                    a = [int]
                    b = [int]
                }
                Outputs = @([int])
            }

            @{
                Name    = 'Invoke-Sub'
                Inputs  = @{
                    a = [int]
                    b = [int]
                }
                Outputs = @([int])
            }

            @{
                Name    = 'Invoke-Mul'
                Inputs  = @{
                    a = [int]
                    b = [int]
                }
                Outputs = @([int])
            }

            @{
                Name    = 'Invoke-Div'
                Inputs  = @{
                    a = [int]
                    b = [int]
                }
                Outputs = @([int])
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

Describe "Math function feature" -Tag "MathFeature" {
    Context "Invoke-Add" {
        It "Should return 3 when 1 and 2 are passed" {
            Invoke-Add -a 1 -b 2 | Should -Be 3
        }
    }

    Context "Invoke-Sub" {
        It "Should return 1 when 2 and 1 are passed" {
            Invoke-Sub -a 2 -b 1 | Should -Be 1
        }
    }

    Context "Invoke-Mul" {
        It "Should return 6 when 2 and 3 are passed" {
            Invoke-Mul -a 2 -b 3 | Should -Be 6
        }
    }

    Context "Invoke-Div" {
        It "Should return 2 when 6 and 3 are passed" {
            Invoke-Div -a 6 -b 3 | Should -Be 2
        }
    }
}