BeforeAll {
    $targetModuleFile = Join-Path -Path $PSScriptRoot -ChildPath "CheckNetworkDrive.psm1"
    Import-Module $targetModuleFile -Force -Verbose
}

Describe "Test-NetworkDrive" {
    Context "When the file exists on the network drive" {
        BeforeAll {
            # Mock Test-Path to simulate the file exists
            Mock -CommandName Test-Path -ModuleName 'CheckNetworkDrive' -MockWith {
                return $true
            }
        }
        It "Should return true" {
            $result = Test-NetworkDrive -FilePath "\\network\share\file.txt"
            $result | Should -Be $true
        }
    }

    Context "When the file does not exist on the network drive" {
        It "Should return false" {
            # You can also mock before calling the function
            Mock -CommandName Test-Path -ModuleName 'CheckNetworkDrive' -MockWit { return $false }
            $result = Test-NetworkDrive -FilePath "\\network\share\file.txt"
            $result | Should -Be $false
        }
    }

    Context "Using TestDrive to simulate file operations" {
        BeforeAll {
            # Pester has a concept of TestDrive that is a temporary drive for testing
            New-Variable -Name TestDrive -Value 'TestDrive:' -Option Constant

            Mock -CommandName Test-NetworkDrive -MockWith {
                param (
                    [string]$FilePath
                )
                if( $FilePath -like "$TestDrive*" ) {
                    return Test-Path -Path $FilePath
                }
                return $false
            }
        }
        It "Should return true if the file exists in TestDrive" {
            # Create a file in the TestDrive
            $testFilePath = Join-Path -Path $TestDrive -ChildPath "file.txt"
            New-Item -Path $testFilePath -ItemType File | Out-Null

            $result = Test-NetworkDrive -FilePath $testFilePath
            $result | Should -Be $true
        }

        It "Should return false if the file does not exist in TestDrive" {
            $testFilePath = Join-Path -Path $TestDrive -ChildPath "nonexistentfile.txt"

            $result = Test-NetworkDrive -FilePath $testFilePath
            $result | Should -Be $false
        }
    }
}