BeforeAll {
    # Replace '_test' with an empty string
    $targetModuleFilePath = $PSCommandPath -replace '_test', ''

    # Replace '.Tests.ps1' with '.psm1'
    $targetModuleFilePath = $targetModuleFilePath -replace '\.Tests\.ps1$', '.psm1'
    Import-Module $targetModuleFilePath -Force -Verbose
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