function Format-ZohoHeader {
    param (
        # Client access token to authenticate with
        [string]
        $AccessToken
    )

    # Search for access token if none specified
    if (!$PSBoundParameters.ContainsKey('AccessToken')) {
        Get-Secret -Vault Zoho -AsPlainText -Name 'ACCESS_TOKEN'
    }

    # Generate the headers
    $Headers = @{
        Authorization = "Zoho-Oauthtoken $AccessToken"
        Accept = 'application/vnd.manageengine.sdp.v3+json'
    }

    $Headers
}
