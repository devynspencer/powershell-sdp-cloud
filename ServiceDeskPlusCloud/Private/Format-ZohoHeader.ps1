function Format-ZohoHeader {
    param (
        # Client access token to authenticate with
        $AccessToken = (Get-Secret -Vault Zoho -AsPlainText -Name 'ACCESS_TOKEN'),

        # The accept header to use
        $Accept = 'application/vnd.manageengine.sdp.v3+json',

        # The content type header to use
        $ContentType = 'application/x-www-form-urlencoded'
    )

    # Build header object
    $Headers = @{
        'Authorization' = "Zoho-Oauthtoken $AccessToken"
        'Accept' = $Accept
        'Content-Type' = $ContentType
    }

    Write-Verbose "Constructed headers: $(ConvertTo-Json $Headers -Compress)"

    $Headers
}
