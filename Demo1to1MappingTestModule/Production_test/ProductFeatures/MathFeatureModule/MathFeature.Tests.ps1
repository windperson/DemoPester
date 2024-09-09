BeforeAll {
    . (Resolve-Path $PSScriptRoot\..\..\ImportModule.ps1) -TestScriptPath $PSCommandPath -Verbose:$VerbosePreference
}

Describe "Math function declaration" -Tag "MathFeature", "FunctionDeclaration" {
    BeforeAll {
        . (Resolve-Path $PSScriptRoot\..\..\FunctionVerify.ps1)
        $moduleFunctions = (Get-Module MathFeature).ExportedFunctions.Keys
    }
    It "Should have a function named Invoke-Add()" {
        $moduleFunctions | Should -Contain 'Invoke-Add'
        $target = Get-Command -Name 'Invoke-Add' -CommandType Function -ErrorAction SilentlyContinue
        $designedParamters = @{ 
            a = 'System.Int32'
            b = 'System.Int32' 
        }
        VerifyParameters $target $designedParamters
    }
    It "Should have a function named Invoke-Sub()" {
        $moduleFunctions | Should -Contain 'Invoke-Sub'
        $target = Get-Command -Name 'Invoke-Sub' -CommandType Function -ErrorAction SilentlyContinue
        $designedParamters = @{ 
            a = 'System.Int32'
            b = 'System.Int32' 
        }
        VerifyParameters $target $designedParamters
    }
    It "Should have a function named Invoke-Mul()" {
        $moduleFunctions | Should -Contain 'Invoke-Mul'
        $target = Get-Command -Name 'Invoke-Mul' -CommandType Function -ErrorAction SilentlyContinue
        $designedParamters = @{ 
            a = 'System.Int32'
            b = 'System.Int32' 
        }
        VerifyParameters $target $designedParamters
    }
    It "Should have a function named Invoke-Div()" {
        $moduleFunctions | Should -Contain 'Invoke-Div'
        $target = Get-Command -Name 'Invoke-Div' -CommandType Function -ErrorAction SilentlyContinue
        $designedParamters = @{ 
            a = 'System.Int32'
            b = 'System.Int32' 
        }
        VerifyParameters $target $designedParamters
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