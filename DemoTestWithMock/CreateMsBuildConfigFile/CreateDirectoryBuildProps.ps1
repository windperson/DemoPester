param (
    [string]$FilePath = ".",
    [string]$FileName = "Directory.Build.props"
)
# MSBuild config XML content
$xmlContent = @"
<Project>
    <PropertyGroup Condition=" '`$(Configuration)|`$(Platform)' == 'Release|x64' ">
        <DebugType>pdbonly</DebugType>
    </PropertyGroup>
</Project>
"@

$targetFilePath = Join-Path $FilePath $FileName
# Write the XML content to Directory.Build.props
$xmlContent | Out-File -FilePath $targetFilePath -Encoding utf8
if (-not (Test-Path -Path $targetFilePath)) {
    throw "try to save `"$targetFilePath`" failed"
}