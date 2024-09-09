BeforeAll {
    . (Resolve-Path $PSScriptRoot\..\..\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

Describe "Echo function declaration" -Tag "Echofeature", "FunctionDeclaration" {
    BeforeAll {
        . (Resolve-Path $PSScriptRoot\..\..\FunctionVerify.ps1) 
    }
    It "Should have a function named Show-Message()" {
        $targetExists = Get-Command -Name 'Show-Message' -CommandType Function -ErrorAction SilentlyContinue
        $targetExists | Should -Not -BeNullOrEmpty

        $designedParamters = @{ 
            Message = 'System.String'
         }

        VerifyParameters $targetExists $designedParamters
    }
    It "Should have a function named Show-MessageWithPrefix()" {
        $targetExists = Get-Command -Name 'Show-MessageWithPrefix' -CommandType Function -ErrorAction SilentlyContinue
        $targetExists | Should -Not -BeNullOrEmpty

        $designedParamters = @{ 
            Message = 'System.String'
            Prefix  = 'System.String' 
        }

        VerifyParameters $targetExists $designedParamters
    }
}

Describe "Echo utility function feature" -Tag "EchoUtils" {
    Context "Show-Message" {
        It "Should return 'Hello World' when 'Hello World' is passed" {
            Show-Message -Message 'Hello World' | Should -Be 'Hello World'
        }
    }
    Context "Show-MessageWithPrefix" {
        It "Should return 'Prefix: Hello World' when 'Hello World' and 'Prefix' are passed" {
            Show-MessageWithPrefix -Message 'Hello World' -Prefix 'Prefix' | Should -Be 'Prefix: Hello World'
        }
    }
}