function Remove-ZohoRefreshToken {
    param (
        [Parameter(Mandatory)]
        $RefreshToken
    )

    $Body = @{
        token = $RefreshToken
    }

    $RestMethodParameters = @{
        Uri = "https://accounts.zoho.com/oauth/v2/token/revoke"
        Method = "Post"
        Body = $Body
    }

    Invoke-RestMethod @RestMethodParameters
}