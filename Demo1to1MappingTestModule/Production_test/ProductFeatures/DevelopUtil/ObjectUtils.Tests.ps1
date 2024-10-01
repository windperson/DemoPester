BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

Describe "Echo function API declaration" -Tag "EchoFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
        $ApiDefinition = @(
            @{
                Name        = 'SafelyGetType'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    obj = [object]
                }
                Outputs     = @([System.Type]) # No strictly specified output type for this function
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

Describe "SafelyGetType()" -Tag "ObjectUtils" {

    It "Should return null for null input" {
        SafelyGetType $null | Should -BeNullOrEmpty
    }

    It "Should return type of input string" {
        $testInput = "TestString"
        $result = SafelyGetType -obj $testInput
        $result | Should -BeExactly $testInput.GetType()
    }

    It "Should return type of input array" {
        $testInput = @()
        $result = SafelyGetType -obj $testInput
        $result | Should -BeExactly $testInput.GetType()
    }

    It "Should return type of custom PSObject input " {
        $testInput = [PSCustomObject]@{Name = "TestName"; Value = "TestValue" }
        $result = SafelyGetType -obj $testInput
        $result | Should -BeExactly $testInput.GetType()
    }
}