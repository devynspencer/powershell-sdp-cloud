function Format-ZohoHeader {
    param (
        # Client access token to authenticate with
        [string]
        $AccessToken
    )

    # Search for access token if none specified
    if (!$PSBoundParameters.ContainsKey('AccessToken')) {
        $AccessToken = Get-Secret -Vault Zoho -AsPlainText -Name 'ACCESS_TOKEN'
    }

    # Build header object
    $Headers = @{
        Authorization = "Zoho-Oauthtoken $AccessToken"
        Accept = 'application/vnd.manageengine.sdp.v3+json'
    }

    $Headers
}
