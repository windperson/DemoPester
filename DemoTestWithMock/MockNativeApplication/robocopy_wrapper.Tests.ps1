#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion

Describe "robocopy_wrapper functional tests" {
    function IsRobocopyAvailable {
        if (Get-Command -Name "robocopy.exe" -ErrorAction SilentlyContinue) {
            return $true
        }
        return $false
    }
    Context "Using TestDrive to simulate file operations" {

        # Skip the tests if robocopy.exe is not available on the system
        It "Should copy files from source to destination" -Skip:(-not (IsRobocopyAvailable)) {
            # Arrange
            # create source test files in the TestDrive
            $source = Join-Path -Path $TestDrive -ChildPath "source"
            if (-not (Test-Path $source)) {
                New-Item -Path $source -ItemType Directory | Out-Null
            }
            New-Item -Path (Join-Path -Path $source -ChildPath "file1.txt") -ItemType File | Out-Null
            New-Item -Path (Join-Path -Path $source -ChildPath "file2.txt") -ItemType File | Out-Null
            New-Item -Path (Join-Path -Path $source -ChildPath "file3.txt") -ItemType File | Out-Null
            # create destination directory in the TestDrive
            $destination = Join-Path -Path $TestDrive -ChildPath "destination"
            if (-not (Test-Path $destination)) {
                New-Item -Path $destination -ItemType Directory | Out-Null
            }
            else {
                # Clean up the destination directory
                Remove-Item -Path $destination -Recurse -Force
            }

            # Act
            . "$PSScriptRoot\robocopy_wrapper.ps1" -Source $source -Destination $destination
            $destinationFiles = Get-ChildItem -Path $destination
            $destinationFiles | Should -HaveCount 3
            $destinationFiles | ForEach-Object {
                $_.Name | Should -BeIn "file1.txt", "file2.txt", "file3.txt"
            }
        }
    }

    Context "Mocking robocopy.exe" {
        BeforeAll {
            function PrintNativeCommandArguments {
                param(
                    [string] $commandName,
                    [object[]]$inputArgs
                )
                $displayArgs = '"{0}"' -f ( $inputArgs -join '", "')
                $originalPreference = $DebugPreference
                $DebugPreference = 'Continue'
                Write-Debug -Message "call '$commandName' with arguments: $displayArgs"
                $DebugPreference = $originalPreference
            }
        }
        It "Should call robocopy.exe with the correct arguments" -Skip:(-not (IsRobocopyAvailable)) {
            # Arrange
            # Mock the robocopy.exe command
            Mock robocopy.exe {
                # NOTE: On mock Native application/commands,
                # Pester Binding mock arguments are passed as the '$args' object array, not the '$PesterBoundParameters' hashtable
                PrintNativeCommandArguments 'robocopy.exe' $args
                # do nothing
            }
            $source = "C:\non_exist_source"
            $destination = "C:\non_exist_destination"

            # Act
            . "$PSScriptRoot\robocopy_wrapper.ps1" -Source $source -Destination $destination

            # Assert
            Assert-MockCalled robocopy.exe -Exactly 1 -ParameterFilter { $args[0] -eq $source -and $args[1] -eq $destination }
        }
        It "Should throw an error when robocopy.exe fails" -Skip:(-not (IsRobocopyAvailable)) {
            # Arrange
            # Mock the robocopy.exe command
            Mock robocopy.exe {
                PrintNativeCommandArguments 'robocopy.exe' $args
                $global:LASTEXITCODE = 16
                # do nothing
            }
            $source = "C:\fake_source"
            $destination = "C:\fake_destination"

            # Act and Assert
            { . "$PSScriptRoot\robocopy_wrapper.ps1" -Source $source -Destination $destination } |
            Should -Throw -ExpectedMessage "robocopy failed with exit code 16"
        }
    }
}