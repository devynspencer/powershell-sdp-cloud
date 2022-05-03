function ConvertTo-UnixMillisecond {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Date
    )

    ([Int64] (Get-Date $Date -UFormat %s)) * 1000
}
