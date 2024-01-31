function Format-ZohoHeader {
    param (
        # Client access token to authenticate with
        $AccessToken = (Get-Secret -Vault Zoho -AsPlainText -Name 'ACCESS_TOKEN'),

        $Accept = 'application/vnd.manageengine.sdp.v3+json',

        $ContentType = 'application/x-www-form-urlencoded'
    )

    # Build header object
    $Headers = @{
        'Authorization' = "Zoho-Oauthtoken $AccessToken"
        'Accept' = $Accept
        'Content-Type' = $ContentType
    }

    Write-Verbose "Constructed headers:`n$(ConvertTo-Json $Headers)"

    $Headers
}
