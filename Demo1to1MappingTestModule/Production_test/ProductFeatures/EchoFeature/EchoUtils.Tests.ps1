#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion

BeforeAll {
    $UtiltiyModulePath = "$PSScriptRoot\..\..\"
    . (Resolve-Path $UtiltiyModulePath\ImportModule.ps1) -TestScriptPath $PSCommandPath -PsFileExtension 'ps1' -Verbose:$VerbosePreference
}

#region Module definition tests
Describe "Echo function API declaration" -Tag "EchoFeature", "FunctionDeclaration" {
    BeforeDiscovery {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Used in Pester Data driven tests')]
        $ApiDefinition = @(
            @{
                Name        = 'Show-Message'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    Message = [string]
                }
                Outputs     = @() # No strictly specified output type for this function
            }
            @{
                Name        = 'Show-TimeStampedMessage'
                CommandType = [System.Management.Automation.CommandTypes]::Function;
                Inputs      = @{
                    Message = [string]
                }
                Outputs     = @([System.Void]) # This function does not return anything
            }
            @{
                Name   = 'Show-MessageWithPrefix';
                # CommandType = [System.Management.Automation.CommandTypes]::Function; # Default value is Function
                Inputs = @{
                    Message = [string]
                    Prefix  = [string]
                }
                # Outputs     = @() # If no strictly specified output type it can be omitted
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