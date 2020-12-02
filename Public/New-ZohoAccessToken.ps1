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

    $Body = @{
        code = $GrantToken
        grant_type = "authorization_code"
        client_id = $ClientId
        client_secret = $ClientSecret
    }

    if ($RedirectUri) {
        $Body.redirect_uri = $RedirectUri
    }

    $RestMethodParameters = @{
        Uri = "https://accounts.zoho.com/oauth/v2/token"
        Method = "Post"
        Body = $Body
    }

    Invoke-RestMethod @RestMethodParameters
}