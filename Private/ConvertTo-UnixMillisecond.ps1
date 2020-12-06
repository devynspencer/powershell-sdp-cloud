function ConvertTo-UnixMillisecond {
    param (
        [Parameter(Mandatory)]
        $Date
    )

    ([Int64] (Get-Date $Date -UFormat %s)) * 1000
}