function Update-ZohoAccessToken {
    param (
        [Parameter(Mandatory)]
        $RefreshToken,

        [Parameter(Mandatory)]
        $ClientId,

        [Parameter(Mandatory)]
        $ClientSecret,

        $RedirectUri,

        [Parameter(Mandatory)]
        $Scope
    )

    $Uri = "https://accounts.zoho.com/oauth/v2/token"

    $Body = @{
        refresh_token = $RefreshToken
        grant_type = "refresh_token"
        client_id = $ClientId
        client_secret = $ClientSecret
        scope = $Scope
    }

    if ($RedirectUri) {
        $Body.redirect_uri = $RedirectUri
    }

    $RestMethodParameters = @{
        Uri = $Uri
        Method = "Post"
        Body = $Body
    }

    Invoke-RestMethod @RestMethodParameters
}