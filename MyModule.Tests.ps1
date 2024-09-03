BeforeAll {
    Import-Module $PSScriptRoot/MyModule.psm1 -Force
}

Describe "Get-Something" {
    Context "verify module has defined functions" {
        BeforeAll{
            $moduleFunctions = (Get-Module MyModule).ExportedFunctions.Keys
        }
        It "Should have a function named Get-Something" {
            $moduleFunctions | Should -Contain 'Get-Something'
        }
    }

    Context "testing parameter ThingToGet" {
        It "Should have a parameter named ThingToGet" {
            Get-Command Get-Something | Should -HaveParameter ThingToGet -Type string
            Get-Command Get-Something | Should -HaveParameter ThingToGet -DefaultValue "something"
            Get-Command Get-Something | Should -HaveParameter ThingToGet -Not -Mandatory
        }
    }

    Context "When ThingToGet is not provided" {
        It "Should return 'I got something'" {
            Get-Something | Should -Be "I got something!"
        }

        It "should be a string" {
            Get-Something | Should -BeOfType System.String
        }
    }
    Context "When ThingToGet is provided" {
        It "Should return 'I got $ThingToGet'" {
            $thing = 'a dog'
            Get-Something -ThingToGet $thing | Should -Be "I got $thing!"
        }
    }

}