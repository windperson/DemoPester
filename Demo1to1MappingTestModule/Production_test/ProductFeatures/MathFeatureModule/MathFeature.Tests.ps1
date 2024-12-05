#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion

#region Analyzer settings
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Scope = 'Function')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Scope = 'Function')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
param()
#endregion

BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -Verbose:$VerbosePreference
}

#region Module definition tests
Describe "Math function API declaration" -Tag "MathFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
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
#endregion

#region Module methods tests
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

#region Pester Custom Assertion operator registration
function Should-BeEqualWithPrecision ( [double] $ActualValue, [double] $ExpectValue, [uint] $Precision,
    [switch] $Negate,
    [string] $Because
) {
    $pass = [math]::Round($ActualValue, $Precision) -eq [math]::Round($ExpectValue, $Precision)
    if ($Negate) {
        $pass = -not $pass
    }

    if (-not $pass) {
        if ($Negate) {
            $failureMessage = "Expected '$ActualValue' to not be equal to $ExpectValue$(if($Because) { " because $Because"})."
        }
        else {
            $failureMessage = "Expected '$ActualValue' to be equal to $ExpectValue$(if($Because) { " because $Because"})."
        }
    }

    return [pscustomobject]@{
        Succeeded      = $pass
        FailureMessage = $failureMessage
    }
}

Add-ShouldOperator -Name BeEqualWithPrecision -Test ${Function:Should-BeEqualWithPrecision}
#endregion

Describe "Math function feature" -Tag "MathFormula" {
    Context "Calculate-Circumference" {
        It "Should return 31.40 when input 5" {
            InModuleScope MathFeature {
                $Global:PI = 3.14
            }
            $expect = 31.4
            $actual = Calculate-Circumference 5
            $actual | Should -BeOfType [double]

            # Because floating point number residue error, we need to compare only in certain precision
            [math]::Round($actual, 2) | Should -Be $([math]::Round($expect, 2))

            # Use a custom assertion to compare the double values
            $actual | Should -BeEqualWithPrecision -ExpectValue $expect -Precision 2
        }
    }
}
#endregion