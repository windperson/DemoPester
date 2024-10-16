param(
    [string] $formatterString = 'yyyy-MM-dd HH:mm:ss'
)

$formatter = $formatterString
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