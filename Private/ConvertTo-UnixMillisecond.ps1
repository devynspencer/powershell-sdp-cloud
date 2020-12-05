function ConvertTo-UnixMillisecond {
    param (
        $Date
    )

    ([Int64] (Get-Date $Date -UFormat %s)) * 1000
}