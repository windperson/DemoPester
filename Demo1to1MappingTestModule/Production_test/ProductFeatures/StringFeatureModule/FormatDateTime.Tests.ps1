#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion

#region Module definition tests
Describe "String function declaration" -Tag "FormatDatetime", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
        $ApiDefinition = @(
            @{
                Name    = 'Get-FixedFormattedDateTimeNow'
                Inputs  = @{
                }
                Outputs = @([string])
            },
            @{
                Name    = 'Get-FormattedDateTimeNow'
                Inputs  = @{
                    formatter = [string]
                }
                Outputs = @([string])
            }
        )
    }

    BeforeAll {
        <# Dummy function to let Pester know the function signature so the latter Mock can work. #>
        function CorrectInput($formatterString) {
            Write-Information -MessageData "--- Use dummy 'CorrectInput()' function ---" -InformationAction Continue
            return $formatterString
        }

        Mock -CommandName CorrectInput {
            Write-Information -MessageData "=== Use mocked 'CorrectInput()' function ===" -InformationAction Continue
            $inputFormatter = $PesterBoundParameters['formatterString']
            return $inputFormatter
        }

        <# Remove original dummy function since we don't need it any more. #>
        Remove-Item Function:CorrectInput

        $UtiltiyModulePath = "$PSScriptRoot\..\..\"
        Write-Information -MessageData "Import target test .ps1 script and its CorrectInput() function should be mocked..." -InformationAction Continue
        . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
        . (Resolve-Path $UtiltiyModulePath\VerifyPsDefApi.ps1)
    }

    It "Should have API `'<Name>`' defined in ApiDefinition" -ForEach $ApiDefinition {
        VerifyApiDefinition -Name $Name -CommandType $CommandType
    }

    It "Should have default formatter `$formatter = 'yyyy-MM-dd HH:mm:ss'" {
        Remove-Module -Name FormatDateTime -Force -ErrorAction Stop
        . "$PSScriptRoot\..\..\..\Production\ProductFeatures\StringFeatureModule\FormatDateTime.ps1"
        Test-Path -Path Variable:\formatter | Should -Be $true
        $formatter | Should -Be 'yyyy-MM-dd HH:mm:ss'
    }
}
#endregion

Describe "FormatDatetime script function(s) implementation" -Tag "FormatDatetime" {
    Context "Get-FixedFormattedDateTimeNow" {
        BeforeAll {
            Remove-Module -Name FormatDateTime -Force -ErrorAction SilentlyContinue
            if (Test-Path Alias:CorrectInput) {
                Write-Information "Remove mocked dummy function"
                Remove-Alias CorrectInput
            }

            Write-Information -MessageData "Dot-sourcing target test .ps1 script and its CorrectInput() function..." -InformationAction Continue
            . "$PSScriptRoot\..\..\..\Production\ProductFeatures\StringFeatureModule\FormatDateTime.ps1"
        }
        It "Should return formatted date time string" {
            $result = Get-FixedFormattedDateTimeNow
            $result | Should -Match '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
        }
    }

    Context "Get-FormattedDateTimeNow" {
        BeforeAll {
            Remove-Module -Name FormatDateTime -Force -ErrorAction SilentlyContinue
            . "$PSScriptRoot\..\..\..\Production\ProductFeatures\StringFeatureModule\FormatDateTime.ps1"
        }
        It "Should return formatted date time string" {
            $result = Get-FormattedDateTimeNow
            $result | Should -Match '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
        }

        It "Should return formatted date time string with custom formatter" {
            $result = Get-FormattedDateTimeNow -formatter 'yyyy-MM-dd'
            $result | Should -Match '^\d{4}-\d{2}-\d{2}$'
        }
    }

    Context "Use valid Formatter specified at Import time" {
        BeforeAll {
            Remove-Module -Name FormatDateTime -Force -ErrorAction SilentlyContinue
            Import-Module -Name "$PSScriptRoot\..\..\..\Production\ProductFeatures\StringFeatureModule\FormatDateTime.ps1" -ArgumentList "HH:mm:ss" -Force -Verbose
        }

        It "'Get-FixedFormattedDateTimeNow()' Should return formatted date time string formatted as 'HH:mm:ss'" {
            $result = Get-FixedFormattedDateTimeNow
            $result | Should -Match '^\d{2}:\d{2}:\d{2}$'
        }

        It "'Get-FormattedDateTimeNow()' Should return formatted date time string formatted as 'HH:mm:ss' with custom formatter when no formatter is passed" {
            $result = Get-FormattedDateTimeNow
            $result | Should -Match '^\d{2}:\d{2}:\d{2}$'
        }

        It "'Get-FormattedDateTimeNow()' Should return formatted date time string formatted as 'yyyy-MM-dd' with formatter argument" {
            $result = Get-FormattedDateTimeNow -formatter 'yyyy-MM-dd'
            $result | Should -Match '^\d{4}-\d{2}-\d{2}$'
        }

        AfterAll {
            Remove-Module -Name FormatDateTime -Force -ErrorAction SilentlyContinue
        }
    }

    Context "Use invliad Formatter specified at import time" {
        BeforeAll {
            Remove-Module -Name FormatDateTime -Force -ErrorAction SilentlyContinue
        }

        It "Use wrong formatter string input: 'aabbcc' `nshould be correct back to default formatter: 'yyyy-MM-dd HH:mm:ss'" {
            Import-Module -Name "$PSScriptRoot\..\..\..\Production\ProductFeatures\StringFeatureModule\FormatDateTime.ps1" -ArgumentList "aabbcc" -Force -Verbose

            Test-Path -Path Variable:\formatter | Should -Be $true
            $formatter | Should -Be 'yyyy-MM-dd HH:mm:ss' -Because "Invalid Formatter string should be correct back to default one"
        }
    }
}