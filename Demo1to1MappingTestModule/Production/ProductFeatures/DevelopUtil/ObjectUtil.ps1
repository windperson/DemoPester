function SafelyGetType {
    [OutputType([System.Type])]
    param($obj)

    process {
        if ($null -eq $obj) { return $null }

        return $obj.GetType()
    }
}


