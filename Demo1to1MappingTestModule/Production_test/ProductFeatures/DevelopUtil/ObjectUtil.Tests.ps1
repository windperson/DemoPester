BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

Describe "Echo function API declaration" -Tag "EchoFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        $ApiDefinition = @(
            @{
                Name        = 'SafelyGetType'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    obj = [object]
                }
                Outputs     = @([System.Type]) # No strictly specified output type for this function
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