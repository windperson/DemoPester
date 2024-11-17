BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

#region Module definition tests
Describe "DevelopUtil function API declaration" -Tag "ConfigFileUtils", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
        $ApiDefinition = @(
            @{
                Name        = 'Set-FileLineComment'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    filePath      = [string]
                    searchPattern = [string]
                    commentText   = [string]
                }
                # Outputs     = @([void])
            }
        )
    }
    BeforeAll {
        . (Resolve-Path $UtiltiyModulePath\VerifyPsDefApi.ps1)
    }

    It "Should have API `'<Name>`' defined in ApiDefinition" -ForEach $ApiDefinition {
        VerifyApiDefinition -Name $Name -CommandType $CommandType
    }
}
#endregion

Describe "Set-FileLineComment" -Tag "ConfigFileUtils" {
    BeforeAll {
        Mock Write-Output { }
        Copy-Item (Resolve-Path $PSScriptRoot\TargetTestFiles\Test.ini).Path $TestDrive
        $Test_IniPath = Join-Path $TestDrive "Test.ini"
        if (-not (Test-Path $Test_IniPath)) {
            Set-ItResult -Inconclusive -Because "Test file '$Test_IniPath' not found"
            return
        }
        Copy-Item (Resolve-Path $PSScriptRoot\TargetTestFiles\Test.ps1).Path $TestDrive
        $Test_Ps1Path = Join-Path $TestDrive "Test.ps1"
        if (-not (Test-Path $Test_Ps1Path)) {
            Set-ItResult -Inconclusive -Because "Test file '$Test_Ps1Path' not found"
            return
        }
    }

    It 'Should be able to comment file with default "#"' {
        # Arrange
        # Act
        Set-FileLineComment -filePath $Test_IniPath -searchPattern "ABC=123"
        Set-FileLineComment -filePath $Test_Ps1Path -searchPattern 'remove-item -Recurse ".*\*.pdb"'

        # Assert
        $commentedIniLine = (Get-Content $Test_IniPath -TotalCount 2 -ReadCount 2)[-1]
        $commentedIniLine | Should -BeExactly '#ABC=123'

        $commentedPs1Line = (Get-Content $Test_Ps1Path -TotalCount 23 -ReadCount 23)[-1]
        $commentedPs1Line | Should -BeLikeExactly '#*'
    }

    It "Should not modify the file when no match pattern found" {
        # Arrange
        $sourceIniContent = Get-Content $Test_IniPath
        $sourcePs1Content = Get-Content $Test_Ps1Path

        # Act
        Set-FileLineComment -filePath $Test_IniPath -searchPattern "ABC=124"
        Set-FileLineComment -filePath $Test_Ps1Path -searchPattern 'remove-item -Recurse ".*\*.bdb"'

        # Assert
        $targetIniContent = Get-Content $Test_IniPath
        $compareIniResult = Compare-Object -ReferenceObject $sourceIniContent -DifferenceObject $targetIniContent -CaseSensitive
        $compareIniResult | Should -BeNullOrEmpty

        $targetPs1Content = Get-Content $Test_Ps1Path
        $comparePs1Result = Compare-Object -ReferenceObject $sourcePs1Content -DifferenceObject $targetPs1Content -CaseSensitive
        $comparePs1Result | Should -BeNullOrEmpty
    }
}
