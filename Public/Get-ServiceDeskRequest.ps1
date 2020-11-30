function Get-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Id,

        [Parameter(Mandatory)]
        $Portal
    )

    $Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$Id"

    $Headers = @{
        Authorization = "Zoho-oauthtoken $AccessToken"
        Accept = "application/v3+json"
    }

    Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers
}