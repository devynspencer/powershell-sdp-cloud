function Request-ZohoAccessToken {
    [CmdletBinding(DefaultParameterSetName = 'FromParams')]
    param (
        # Zoho grant token to exchange for an access token
        [Parameter(ParameterSetName = 'FromParams')]
        $RefreshToken,

        # Zoho API client ID string to use for client auth
        [Parameter(ParameterSetName = 'FromParams')]
        $ClientId,

        # Zoho API client secret string to use for client auth
        [Parameter(ParameterSetName = 'FromParams')]
        $ClientSecret,

        # Filesystem path of downloaded JSON file containing access request information
        [Parameter(Mandatory, ParameterSetName = 'FromFile')]
        $FilePath,

        # Do not save auth tokens from response in secret store
        [switch]
        $NoSave,

        # Return response
        [switch]
        $PassThru
    )

    # Retrieve secrets
    $SecretParams = @{
        AsPlainText = $true
        Vault = 'Zoho'
        ErrorAction = 'Stop'
    }

    if (!$PSBoundParameters.ContainsKey('RefreshToken')) {
        $RefreshToken = Get-Secret @SecretParams -Name 'REFRESH_TOKEN'
    }

    if (!$PSBoundParameters.ContainsKey('ClientId')) {
        $ClientId = Get-Secret @SecretParams -Name 'CLIENT_ID'
    }

    if (!$PSBoundParameters.ContainsKey('ClientSecret')) {
        $ClientSecret = Get-Secret @SecretParams -Name 'CLIENT_SECRET'
    }

    # Build request
    switch ($PSCmdlet.ParameterSetName) {
        'FromParams' {
            $Body = @{
                code = $GrantToken
                grant_type = 'refresh_token'
                client_id = $ClientId
                client_secret = $ClientSecret
            }
        }

        'FromFile' {
            $FileContent = Get-Content -Raw -Path $FilePath | ConvertFrom-Json

            $Body = @{
                code = $FileContent.code
                grant_type = $FileContent.grant_type
                client_id = $FileContent.client_id
                client_secret = $FileContent.client_secret
            }
        }
    }

    # Record next expiration time
    $script:ZohoAccessExpirationTime = (Get-Date).AddHours(1)

    # Execute request
    $RestMethodParameters = @{
        Uri = 'https://accounts.zoho.com/oauth/v2/token'
        Method = 'Post'
        Body = $Body
    }

    $Response = Invoke-RestMethod @RestMethodParameters

    # Handle response

    # Store secrets from response
    if (!$NoSave) {
        $SecretParams.Remove('AsPlainText')
        Set-Secret @SecretParams -Name 'ACCESS_TOKEN' -Secret $Response.access_token
    }

    # Format output
    if ($PassThru) {
        $Response
    }
}
