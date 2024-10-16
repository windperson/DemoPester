BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

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
        . (Resolve-Path $UtiltiyModulePath\VerifyPsDefApi.ps1)
    }

    It "Should have API `'<Name>`' defined in ApiDefinition" -ForEach $ApiDefinition {
        VerifyApiDefinition -Name $Name -CommandType $CommandType
    }

    It "Should have default formatter `$formatter = 'yyyy-MM-dd HH:mm:ss'" {
        Remove-Module -Name FormatDateTime -Force -ErrorAction Stop
        . "$PSScriptRoot\..\..\..\Production\ProductFeatures\StringFeatureModule\FormatDateTime.ps1"
        # $formatter = Get-Variable -Name formatter -Scope local
        Test-Path -Path Variable:\formatter | Should -Be $true
        $formatter | Should -Be 'yyyy-MM-dd HH:mm:ss'
    }
}

Describe "FormatDatetime script function(s) implementation" -Tag "FormatDatetime" {
    BeforeAll {
        Remove-Module -Name FormatDateTime -Force -ErrorAction SilentlyContinue
        . "$PSScriptRoot\..\..\..\Production\ProductFeatures\StringFeatureModule\FormatDateTime.ps1"
    }

    Context "Get-FixedFormattedDateTimeNow" {
        It "Should return formatted date time string" {
            $result = Get-FixedFormattedDateTimeNow
            $result | Should -Match '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
        }
    }

    Context "Get-FormattedDateTimeNow" {
        It "Should return formatted date time string" {
            $result = Get-FormattedDateTimeNow
            $result | Should -Match '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$'
        }

        It "Should return formatted date time string with custom formatter" {
            $result = Get-FormattedDateTimeNow -formatter 'yyyy-MM-dd'
            $result | Should -Match '^\d{4}-\d{2}-\d{2}$'
        }
    }

    Context "Use Formatter specified at Import time" {
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
}