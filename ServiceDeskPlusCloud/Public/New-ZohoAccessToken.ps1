function New-ZohoAccessToken {
    [CmdletBinding(DefaultParameterSetName = "FromFile")]
    param (
        [Parameter(Mandatory, ParameterSetName = "FromParams")]
        $GrantToken,

        [Parameter(Mandatory, ParameterSetName = "FromParams")]
        $ClientId,

        [Parameter(Mandatory, ParameterSetName = "FromParams")]
        $ClientSecret,

        [Parameter(Mandatory, ParameterSetName = "FromFile")]
        $FilePath
    )

    if ($PSBoundParameters.ContainsKey("FilePath")) {
        $FileContent = Get-Content -Raw -Path $FilePath | ConvertFrom-Json
        $Body = @{
            code = $FileContent.code
            grant_type = $FileContent.grant_type
            client_id = $FileContent.client_id
            client_secret = $FileContent.client_secret
        }
    }

    else {
        $Body = @{
            code = $GrantToken
            grant_type = "authorization_code"
            client_id = $ClientId
            client_secret = $ClientSecret
        }
    }

    $RestMethodParameters = @{
        Uri = "https://accounts.zoho.com/oauth/v2/token"
        Method = "Post"
        Body = $Body
    }

    Invoke-RestMethod @RestMethodParameters
}