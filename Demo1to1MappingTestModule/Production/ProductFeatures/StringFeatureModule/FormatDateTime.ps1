#Requires -Version 7
param(
    [string] $formatterString = 'yyyy-MM-dd HH:mm:ss'
)

function CorrectInput($formatterString) {
    Write-Information "CorrectInput() declared in `"$(Split-Path -Leaf $PSCommandPath)`", input `$formatterString=$formatterString" `
        -InformationAction Continue

    function IsValidFormat {
        param(
            [string] $formatStr
        )
        if ([String]::IsNullOrEmpty($formatStr)) {
            return $false
        }
        <#
        Check $formatterString is valid by examing if it contains any fomrat symbol character(s)
        #>
        $vaildFormatterSymbols = @('d', 'D', 'f', 'F', 'g', 'G', 'h', 'H', 'm', 'M', 'o', 'O', 'r', 'R', 's', 'S', 't', 'T', 'u', 'U', 'y', 'Y', 'z', 'Z')
        $inputFormatChars = [char[]]$formatStr
        foreach ($symbols in $vaildFormatterSymbols) {
            if ($inputFormatChars -contains $symbols) {
                return $true
            }
        }
        return $false
    }

    return (IsValidFormat $formatterString)? $formatterString : 'yyyy-MM-dd HH:mm:ss'
}

$formatter = CorrectInput($formatterString)

function Get-FixedFormattedDateTimeNow {
    [OutputType([string])]
    param()
    return (Get-Date).ToString($formatter)
}

function Get-FormattedDateTimeNow {
    [OutputType([string])]
    param(
        [string] $formatter = $formatter
    )
    return (Get-Date).ToString($formatter)
}