BeforeAll {
    . (Resolve-Path $PSScriptRoot\..\..\ImportModule.ps1) -TestScriptPath $PSCommandPath
}

Describe "Math function declaration" {
    BeforeAll {
        $moduleFunctions = (Get-Module MathFeature).ExportedFunctions.Keys
    }
    It "Should have a function named Invoke-Add()" {
        $moduleFunctions | Should -Contain 'Invoke-Add'
    }
    It "Should have a function named Invoke-Sub()" {
        $moduleFunctions | Should -Contain 'Invoke-Sub'
    }
    It "Should have a function named Invoke-Mul()" {
        $moduleFunctions | Should -Contain 'Invoke-Mul'
    }
    It "Should have a function named Invoke-Div()" {
        $moduleFunctions | Should -Contain 'Invoke-Div'
    }
}

Describe "Math function feature" {
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