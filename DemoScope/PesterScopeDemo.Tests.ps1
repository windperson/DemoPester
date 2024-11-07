BeforeAll {
    $myVar = "This is a semi global variable"
}

Describe "testing PesterScopeDemo.psm1" {
    BeforeAll {
        # Remove-Module -Name PesterScopeDemo -Verbose -ErrorAction Continue
        Import-Module "$PSScriptRoot/PesterScopeDemo.psm1" -Verbose -Force
    }
    Context "test Get-Greeting() function without Mocking" {
        It "default value" {
            Get-Greeting | Should -Be "Hello, World!"
        }
        It "customer GreeterName" {
            Set-GreeterName -GreeterName "Pester"
            Get-Greeting | Should -Be "Hello, Pester!"
        }
    }
    Context "test Set-GreeterName() function with Mocking" {
        It "use InModuleScope to verify script level variable" {
            # Arrange
            Set-Variable MyDemoGreeter -Scope global -Option Constant `
                -Value 'Pester_InModuleScope'

            # Act
            Set-GreeterName -GreeterName $MyDemoGreeter
            # Assert
            InModuleScope 'PesterScopeDemo' {
                $script:name | Should -Be $MyDemoGreeter
            }
        }
    }
}

