### NOTE: thia is A demo ps1 script for being manipulated by ConfigFileUtils.ps1
### DO NOT REALLY RUN this script!!!
#<#
.SYNOPSIS


.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function RemoveDebugSymbol {
    parma(
        [string]$projectDir,
        [string]$buildConfiguration = 'Release'
    )

    if ($buildConfiguration -eq "Release") {
        remove-item -Recurse "$projectDir\**\bin\*.pdb"
        remove-item -Recurse "$projectDir\**\obj\*.obj"
    }
}