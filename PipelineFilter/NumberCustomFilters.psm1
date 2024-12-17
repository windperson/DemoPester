filter IsOddNumber {
    if ($_ % 2 -ne 0) {
        return $_
    }
}

filter IsEvenNumber {
    if ($_ % 2 -eq 0) {
        return $_
    }
}

filter IsSmallerThen {
    param(
        [int] $UpLimit
    )
    if ($_ -le $UpLimit) {
        return $_
    }
}

filter IsLargerThen {
    param (
        [int] $LowLimit
    )
    if ($_ -ge $LowLimit) {
        return $_
    }
}

filter IsInTheRange {
    param(
        [int] $LowerLimit,
        [int] $UpperLimit
    )
    $_ | IsLargerThen -LowLimit $LowerLimit | IsSmallerThen -UpLimit $UpperLimit | ForEach-Object {
        return $_
    }
}