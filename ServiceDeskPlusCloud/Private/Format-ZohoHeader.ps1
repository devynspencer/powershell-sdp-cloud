function Format-ZohoHeader {
    param (
        # Client access token to authenticate with
        $AccessToken = (Get-Secret -Vault Zoho -AsPlainText -Name 'ACCESS_TOKEN')
    )

    # Build header object
    $Headers = @{
        Authorization = "Zoho-Oauthtoken $AccessToken"
        Accept = 'application/vnd.manageengine.sdp.v3+json'
    }

    $Headers
}
