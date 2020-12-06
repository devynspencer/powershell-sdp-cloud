function Remove-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Id
    )

    $Headers = @{
        Authorization = "Zoho-oauthtoken $AccessToken"
        Accept = "application/vnd.manageengine.sdp.v3+json"
    }

    $RestMethodParameters = @{
        Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$Id"
        Headers = $Headers
        Method = "Delete"
    }

    Invoke-RestMethod @RestMethodParameters
}