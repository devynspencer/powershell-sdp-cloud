function New-ZohoAccessToken {
    param (
        [Parameter(Mandatory)]
        $GrantToken,

        [Parameter(Mandatory)]
        $ClientId,

        [Parameter(Mandatory)]
        $ClientSecret,

        $RedirectUri
    )

    $Uri = "https://accounts.zoho.com/oauth/v2/token?code=$GrantToken&grant_type=authorization_code&client_id=$ClientId&client_secret=$ClientSecret"

    if ($RedirectUri) {
        $Uri = "$Uri&redirect_uri=$RedirectUri"
    }

    Invoke-RestMethod -Method Post -Uri $Uri
}