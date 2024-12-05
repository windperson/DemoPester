#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion

BeforeAll {
    $targetModuleFile = Join-Path -Path $PSScriptRoot -ChildPath "MyModule.psm1"
    Import-Module $targetModuleFile -Force -Verbose
}

Describe "Get-Something" {
    Context "verify module has defined functions" {
        BeforeAll {
            # note: this is for demo, actually you can put this in following test case block.
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
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