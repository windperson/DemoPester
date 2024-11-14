function Get-CurrentTime {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSProvideCommentHelp', '')]
    param()
    $output = (Get-Date).ToString()
    Write-Information -MessageData "In Real Get-CurrentTime() function, `$output=$output" -InformationAction Continue
    return $output
}

function MyDateTime {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSProvideCommentHelp', '')]
    param()
    $time = Get-CurrentTime
    return "The current time is $time"
}

Export-ModuleMember MyDateTime