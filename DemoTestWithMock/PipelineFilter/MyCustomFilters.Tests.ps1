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

Describe "Test IsSmallerThen/IsLargerThen filter" {
    BeforeAll {
        Set-Variable -Name "SourcetNumbers" -Option Constant -Value (1..20)
        Import-Module "$PSScriptRoot\MyCustomFilters.psm1" -Force
    }

    It "IsSmallerThen filter Should return values smaller than or equal to 10 when UpLimit is 10" {
        $expect = 1..10
        $result = $SourcetNumbers | IsSmallerThen -UpLimit 10
        $result | Should -BeExactly $expect
    }

    It "Should return values Larger than or equal to 10 when LowLimit is 10" {
        $expect = 10..20
        $result = $SourcetNumbers | IsLargerThen -LowLimit 10
        $result | Should -BeExactly $expect
    }
}

Describe "Test IsInRange filter"{
    BeforeAll {
        Set-Variable -Name "SourcetNumbers" -Option Constant -Value (1..20)
        Import-Module "$PSScriptRoot\MyCustomFilters.psm1" -Force
    }

    It "Should return 10, 11, 12, 13, 14, 15 when set LowerLimt=10, UpperLimit=15" {
        $expect = 10..15
        $result = $SourcetNumbers | IsInTheRange -LowerLimit 10 -UpperLimit 15
        $result | Should -BeExactly $expect
    }
}