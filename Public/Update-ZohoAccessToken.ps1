function Update-ZohoAccessToken {
    [CmdletBinding(DefaultParameterSetName = "FromFile")]
    param (
        [Parameter(Mandatory)]
        $RefreshToken,

        [Parameter(Mandatory, ParameterSetName = "FromParams")]
        $ClientId,

        [Parameter(Mandatory, ParameterSetName = "FromParams")]
        $ClientSecret,

        [Parameter(Mandatory, ParameterSetName = "FromParams")]
        $Scope,

        [Parameter(Mandatory, ParameterSetName = "FromFile")]
        $FilePath
    )

    $Body = @{
        refresh_token = $RefreshToken
        grant_type = "refresh_token"
    }

    if ($PSBoundParameters.ContainsKey("FilePath")) {
        $FileContent = Get-Content -Raw -Path $FilePath | ConvertFrom-Json
        $Body.client_id = $FileContent.client_id
        $Body.client_secret = $FileContent.client_secret
        $Body.scope = $FileContent.scope -join ','
    }

    else {
        $Body.client_id = $ClientId
        $Body.client_secret = $ClientSecret
        $Body.scope = $Scope
    }

    $RestMethodParameters = @{
        Uri = "https://accounts.zoho.com/oauth/v2/token"
        Method = "Post"
        Body = $Body
    }

    Invoke-RestMethod @RestMethodParameters
}