function ConvertFrom-UnixTimestamp {
    param (
        # The Unix timestamp (in ms) to convert to a date
        [Parameter(Mandatory)]
        [int64]
        $Timestamp
    )

    $ConvertedDate = [System.DateTimeOffset]::FromUnixTimeMilliseconds($Timestamp)

    Get-Date $ConvertedDate.DateTime
}
