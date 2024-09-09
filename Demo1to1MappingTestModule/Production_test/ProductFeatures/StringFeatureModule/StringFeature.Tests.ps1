BeforeAll {
    . (Resolve-Path $PSScriptRoot\..\..\ImportModule.ps1) -TestScriptPath $PSCommandPath -Verbose:$VerbosePreference
}

Describe "String function declaration" -Tag "StringFeature", "FunctionDeclaration" {
    BeforeAll {
        . (Resolve-Path $PSScriptRoot\..\..\FunctionVerify.ps1)
        $moduleFunctions = (Get-Module StringFeature).ExportedFunctions.Keys
    }
    It "Should have a function named Invoke-Cancatenate()" {
        $moduleFunctions | Should -Contain 'Invoke-Cancatenate'
        $target = Get-Command -Name 'Invoke-Cancatenate' -CommandType Function -ErrorAction SilentlyContinue
        $designedParamters = @{ 
            a = 'System.String'
            b = 'System.String' 
        }
        VerifyParameters $target $designedParamters
    }
    It "Should have a function named Invoke-Reverse()" {
        $moduleFunctions | Should -Contain 'Invoke-Reverse'
        $target = Get-Command -Name 'Invoke-Reverse' -CommandType Function -ErrorAction SilentlyContinue
        $designedParamters = @{ 
            aString = 'System.String'
        }
        VerifyParameters $target $designedParamters
    }
}

Describe "String function feature" -Tag "StringFeature" {
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