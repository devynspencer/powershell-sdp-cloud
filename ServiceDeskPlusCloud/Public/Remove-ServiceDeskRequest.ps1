function Remove-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id
    )

    begin {
        $Headers = @{
            Authorization = "Zoho-oauthtoken $AccessToken"
            Accept = "application/vnd.manageengine.sdp.v3+json"
        }
    }

    process {
        foreach ($RequestId in $Id) {
            $RestMethodParameters = @{
                Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$RequestId"
                Headers = $Headers
                Method = "Delete"
            }

            Invoke-RestMethod @RestMethodParameters
        }
    }
}