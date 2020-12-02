function Remove-ZohoRefreshToken {
    param (
        [Parameter(Mandatory)]
        $RefreshToken
    )

    $RestMethodParameters = @{
        Uri = "https://accounts.zoho.com/oauth/v2/token/revoke?token=$RefreshToken"
        Method = "Post"
    }

    Invoke-RestMethod @RestMethodParameters
}