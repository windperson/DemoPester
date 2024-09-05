# import module before creating the object
Import-Module Pester
$config = [PesterConfiguration]::Default
$config.Run.Path = '.\Production_test'
if ($VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue) {
  $config.Output.Verbosity = 'Detailed'
}
$config.Run.Container = New-PesterContainer -ScriptBlock {
  param(
    [System.Management.Automation.ActionPreference] $VerbosePreference
  )
} -Data @{
  VerbosePreference = $VerbosePreference
}

Invoke-Pester -Configuration $config
