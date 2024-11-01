BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

Describe "DevelopUtil function API declaration" -Tag "ConfigFileUtils", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
        $ApiDefinition = @(
            @{
                Name        = 'Set-FileLineComment'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    filePath       = [string]
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
