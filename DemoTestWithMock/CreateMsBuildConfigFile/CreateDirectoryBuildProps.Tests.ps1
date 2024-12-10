#region Script Requirement settings
#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}
#endregion

BeforeAll {
    Set-Variable -Name TestFilePath -Value "TestDrive:\TestOutput" -Option Constant
    Set-Variable -Name TestFileName -Value "Directory.Build.props" -Option Constant
    # Ensure the test output directory exists
    if (-not (Test-Path -Path $TestFilePath)) {
        New-Item -ItemType Directory -Path $TestFilePath | Out-Null
    }
}

AfterAll {
    # Clean up the test output directory
    Remove-Item -Path $TestFilePath -Recurse -Force
}


Describe "CreateDirectoryBuildProps.ps1" {
    It "Should create the file with the correct name and path" {
        . "$PSScriptRoot\CreateDirectoryBuildProps.ps1" -FilePath $TestFilePath -FileName $TestFileName
        $targetFilePath = Join-Path $TestFilePath $TestFileName
        Test-Path -Path $targetFilePath | Should -Be $true
    }

    It "Should write the correct XML content to the file" {
        . "$PSScriptRoot\CreateDirectoryBuildProps.ps1" -FilePath $TestFilePath -FileName $TestFileName
        $targetFilePath = Join-Path $TestFilePath $TestFileName
        $expectedContent = @"
<Project>
    <PropertyGroup Condition=" '`$(Configuration)|`$(Platform)' == 'Release|x64' ">
        <DebugType>pdbonly</DebugType>
    </PropertyGroup>
</Project>
"@
        function CompareFileContent {
            param (
                [string]$ActualContent,
                [string]$ExpectedContent
            )
            $ActualContent = $($ActualContent -replace "\r`n", "`n").TrimEnd("`n")
            $ExpectedContent = $($ExpectedContent -replace "\r`n", "`n").TrimEnd("`n")
            $ActualContent | Should -BeExactly $ExpectedContent
        }

        $actualContent = (Get-Content -Path $targetFilePath -Raw)
        CompareFileContent -ActualContent $actualContent -ExpectedContent $expectedContent
    }

    It "Should throw an error when it fails to create the file" {
        # Simulate a scenario where the file cannot be created
        $invalidFilePath = [System.IO.Path]::GetInvalidPathChars() | ForEach-Object { "TestDrive:\Test$_" } | Get-Random
        { . "$PSScriptRoot\CreateDirectoryBuildProps.ps1" -FilePath $invalidFilePath -FileName $TestFileName } |`
            Should -Throw
    }

    It "Should handle different file paths and names" {
        $customFilePath = "$TestFilePath\Custom"
        # Ensure the test output directory exists
        if (-not (Test-Path -Path $customFilePath)) {
            New-Item -ItemType Directory -Path $customFilePath | Out-Null
        }
        $customFileName = "Custom.Build.props"
        . "$PSScriptRoot\CreateDirectoryBuildProps.ps1" -FilePath $customFilePath -FileName $customFileName
        $targetFilePath = Join-Path $customFilePath $customFileName
        Test-Path -Path $targetFilePath | Should -Be $true
    }
}