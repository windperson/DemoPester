using namespace System.Diagnostics.CodeAnalysis

function SafelyGetType {
    [OutputType([System.Type])]
    param($obj)

    process {
        if ($null -eq $obj) { return $null }

        return $obj.GetType()
    }
}

function Dump-ObjectProps {
    [SuppressMessage('PSUseApprovedVerbs', '')]
    [SuppressMessage('PSUseSingularNouns', '')]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory = $true)]
        [object] $Value,
        [Parameter(Mandatory = $false)]
        [System.Type] $Type = $null,
        [Parameter(Mandatory = $false)]
        [string[]] $PropertiesFilter = @()
    )

    process {
        if ($null -eq $Value) { return $null }
        if ( $null -ne $Type -and $Type -isnot [PSCustomObject]) {
            $typeNames = $Type.GetProperties() | Select-Object -ExpandProperty Name
        }

        return @( Get-Member -InputObject $Value -MemberType Properties | ForEach-Object {
                # If the Type has that property, then get the value
                if ($typeNames.Count -gt 0) {
                    if ($typeNames -contains $_.Name) {
                        "$($_.Name)=$($Value.$($_.Name))"
                    }
                }
                elseif ($PropertiesFilter.Count -gt 0) {
                    if ($PropertiesFilter -contains $_.Name) {
                        "$($_.Name)=$($Value.$($_.Name))"
                    }
                }
                else {
                    "$($_.Name)=$($Value.$($_.Name))"
                }
            })
    }
}


