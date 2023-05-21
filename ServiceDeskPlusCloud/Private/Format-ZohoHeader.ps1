function Format-ZohoHeader {
    param (
        # Client access token to authenticate with
        $AccessToken = (Get-Secret -Vault Zoho -AsPlainText -Name 'ACCESS_TOKEN'),

        $Accept = 'application/vnd.manageengine.sdp.v3+json'
    )

    # Build header object
    $Headers = @{
        Authorization = "Zoho-Oauthtoken $AccessToken"
        Accept = $Accept
    }

    $Headers
}
