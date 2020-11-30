function Remove-ZohoRefreshToken {
    param (
        [Parameter(Mandatory)]
        $RefreshToken
    )

    $Uri = "https://accounts.zoho.com/oauth/v2/token/revoke?token=$RefreshToken"

    Invoke-RestMethod -Method Post -Uri $Uri
}