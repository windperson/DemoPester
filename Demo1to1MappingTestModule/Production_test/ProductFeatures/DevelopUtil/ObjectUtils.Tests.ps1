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
            @{
                Name        = 'Dump-ObjectProps';
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    Value            = [object]
                    'Type'           = [System.Type]
                    PropertiesFilter = [string[]]
                }
                Outputs     = @([string[]])
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

Describe "Dump-ObjectProps" -Tag "ObjectUtils" {

    It "Should return properties of input string" {
        $testInput = "TestString"
        $result = Dump-ObjectProps -Value $testInput
        $result | Should -Contain "Length=10"
    }

    It "Should return properties of input array" {
        $testInput = @()
        $result = Dump-ObjectProps -Value $testInput
        $result | Should -Contain "Length=0"
        $result | Should -Contain "Rank=1"
    }

    It "Should return properties of custom PSObject input " {
        $testInput = [PSCustomObject]@{Name = "TestName"; Value = "TestValue" }
        $result = Dump-ObjectProps -Value $testInput
        $result | Should -Contain "Name=TestName"
        $result | Should -Contain "Value=TestValue"
    }

    It "Should return properties of custom PSObject input with type" {
        $testInput = [PSCustomObject]@{Name = "TestName"; Value = "TestValue" }
        $result = Dump-ObjectProps -Value $testInput -Type ([System.Type]::GetType("System.String"))
        $result | Should -BeNullOrEmpty
    }

    It "Should return properties of custom PSObject input with type" {
        $testInputValue = [PSCustomObject]@{Name = "TestName"; Value = "TestValue" }
        $result = Dump-ObjectProps -Value $testInputValue -PropertiesFilter "Name"
        $result | Should -Contain "Name=TestName"
        $result | Should -Not -Contain "Value=TestValue"
    }

    It "Shoulld return properties of Hashtable input" {
        $testInput = [Ordered]@{Name = "TestName"; Value = "TestValue" }
        $result = Dump-ObjectProps -Value $testInput
        $result | Should -Contain "Count=2"
        $result | Should -Contain "Keys=Name Value"
        $result | Should -Contain "Values=TestName TestValue"
    }
}