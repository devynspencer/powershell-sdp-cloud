function Update-ZohoAccessToken {
    param (
        [Parameter(Mandatory)]
        $RefreshToken,

        [Parameter(Mandatory)]
        $ClientId,

        [Parameter(Mandatory)]
        $ClientSecret,

        $RedirectUri,

        $Scope
    )

    $Uri = " https://accounts.zoho.com/oauth/v2/token?refresh_token=$RefreshToken&grant_type=refresh_token&client_id=$ClientId&client_secret=$ClientSecret&scope=$Scope"

    if ($RedirectUri) {
        $Uri = "$Uri&redirect_uri=$RedirectUri"
    }

    Invoke-RestMethod -Method Post -Uri $Uri
}