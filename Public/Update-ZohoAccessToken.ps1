function Update-ZohoAccessToken {
    param (
        [Parameter(Mandatory)]
        $RefreshToken,

        [Parameter(Mandatory)]
        $ClientId,

        [Parameter(Mandatory)]
        $ClientSecret,

        [Parameter(Mandatory)]
        $Scope
    )

    $Body = @{
        refresh_token = $RefreshToken
        grant_type = "refresh_token"
        client_id = $ClientId
        client_secret = $ClientSecret
        scope = $Scope
    }

    $RestMethodParameters = @{
        Uri = "https://accounts.zoho.com/oauth/v2/token"
        Method = "Post"
        Body = $Body
    }

    Invoke-RestMethod @RestMethodParameters
}