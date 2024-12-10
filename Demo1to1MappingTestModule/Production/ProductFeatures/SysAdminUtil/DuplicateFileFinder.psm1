#Requires -Version 5.1
using namespace System.Diagnostics.CodeAnalysis

class DuplicatedFileInfo {
    [System.IO.FileInfo]$FilePath1
    [System.IO.FileInfo]$FilePath2
}

function Get-FileContentHash {
    [SuppressMessage('PSAvoidUsingBrokenHashAlgorithms', '', Justification = 'MD5 is just used for file hash comparison')]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$FilePath
    )
    return Get-FileHash -Algorithm MD5 -Path $FilePath # -SilentlyContinue
}

function Get-Files {
    [SuppressMessage('PSUseSingularNouns', '')]
    param (
        [string]$Path,
        [string]$Extension
    )
    return Get-ChildItem -Path $Path -Recurse -File -Filter "*.$Extension"
}

function Get-DuplicateFile {
    <#
    .SYNOPSIS
        Find duplicate files in two directories.
    #>
    [OutputType([DuplicatedFileInfo[]])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,
        [Parameter(Mandatory = $true)]
        [string]$ComparePath,
        [Parameter(Mandatory = $false)]
        [string]$CompareFileExtension = "*"
    )


    $sourceFiles = Get-Files -Path $SourcePath -Extension $CompareFileExtension
    $compareFiles = Get-Files -Path $ComparePath -Extension $CompareFileExtension

    $sourceIsLarger = $sourceFiles.Count -gt $compareFiles.Count
    if ( $sourceIsLarger ) {
        $smallerSet = $compareFiles
        $largerSet = $sourceFiles
    }
    else {
        $smallerSet = $sourceFiles
        $largerSet = $compareFiles
    }

    $duplicateFiles = @()

    foreach ($file in $smallerSet) {
        $matchingFiles = $largerSet | Where-Object { $_.Name -eq $file.Name }
        if ($matchingFiles) {
            foreach ($match in $matchingFiles) {
                $sourceHash = Get-FileContentHash -FilePath $file
                $compareHash = Get-FileContentHash -FilePath $match

                if ($sourceHash.Hash -eq $compareHash.Hash) {
                    $duplicateFiles += [DuplicatedFileInfo]@{
                        FilePath1 = if ($sourceIsLarger) { $match } else { $file }
                        FilePath2 = if ($sourceIsLarger) { $file } else { $match }
                    }
                }
            }
        }
    }

    return $duplicateFiles
}

Export-ModuleMember -Function Get-DuplicateFile
