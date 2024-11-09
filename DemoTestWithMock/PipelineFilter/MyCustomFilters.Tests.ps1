Describe "Test Number filters" {
    BeforeAll {
        Set-Variable -Name "TestNumbers" -Option Constant -Value (1..20)
        Import-Module "$PSScriptRoot\MyCustomFilters.psm1" -Force
    }

    It "IsOddNumber filter" {
        # Act
        $result = $TestNumbers | IsOddNumber
        # Assert
        $result | ForEach-Object {
            $_ % 2 | Should -Be 1
        }
    }
    It "IsEvenNumber filter" {
        # Act
        $result = $TestNumbers | IsEvenNumber
        # Assert
        $result | ForEach-Object {
            $_ % 2 | Should -Be 0
        }
    }
}