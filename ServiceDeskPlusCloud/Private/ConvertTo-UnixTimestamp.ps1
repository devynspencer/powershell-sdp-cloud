function ConvertTo-UnixTimestamp {
    param (
        # The date to convert to a Unix timestamp
        [Parameter(Mandatory)]
        [datetime]
        $Date
    )

    ([DateTimeOffset] $Date).ToUnixTimeSeconds() * 1000
}
