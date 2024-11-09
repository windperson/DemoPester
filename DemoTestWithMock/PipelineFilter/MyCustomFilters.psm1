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
        [int] $TopLimit
    )
    if ($_ -le $TopLimit) {
        return $_
    }
}

function IsLargerThen {
    param (
        [int] $LowLimit
    )
    if ($_ -ge $LowLimit) {
        return $_
    }
}