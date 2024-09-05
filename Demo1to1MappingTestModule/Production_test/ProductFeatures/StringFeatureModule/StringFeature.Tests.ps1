BeforeAll {
    . (Resolve-Path $PSScriptRoot\..\..\ImportModule.ps1) -TestScriptPath $PSCommandPath -Verbose:$VerbosePreference
}

Describe "String function declaration" {
    BeforeAll {
        $moduleFunctions = (Get-Module StringFeature).ExportedFunctions.Keys
    }
    It "Should have a function named Invoke-Cancatenate()" {
        $moduleFunctions | Should -Contain 'Invoke-Cancatenate'
    }
    It "Should have a function named Invoke-Reverse()" {
        $moduleFunctions | Should -Contain 'Invoke-Reverse'
    }
}

Describe "String function feature" {
    Context "Invoke-Cancatenate" {
        It "Should return 'ab' when 'a' and 'b' are passed" {
            Invoke-Cancatenate -a 'a' -b 'b' | Should -Be 'ab'
        }
    }

    Context "Invoke-Reverse" {
        It "Should return 'cba' when 'abc' is passed" {
            Invoke-Reverse -a 'abc' | Should -Be 'cba'
        }
    }
}