# ServiceDeskPlusCloud

PowerShell module focused on manipulating the ServiceDeskPlus OnDemand (cloud) API.

## Getting Started

In order to obtain a temporary authorization code to authenticate to the API with, you first need to register a self-client application via the [ZOHO API Client Console](https://api-console.zoho.com/). See the [ManageEngine API documentation](https://www.manageengine.com/products/service-desk/sdpod-v3-api/SDPOD-V3-API.html#authorization-request) on [generating access and refresh tokens](https://www.manageengine.com/products/service-desk/sdpod-v3-api/getting-started/oauth-2.0.html#generate-access-token-and-refresh-token) for more information.

Follow the steps in the documentation to generate a temporary authentication code and supply the value to the `GrantToken` parameter of `New-ZohoAccessToken` or download the `self_client.json` file from the API client console and supply the path via the `FilePath` parameter.

```powershell
# Replace the following examples with those obtained from the Zoho developer portal, obviously
$NewTokenParams = @{
  GrantToken = '1000.f74e7b6fc16c95bbc1fa2f067962f84b.9768e796b6273774817032613ba6892a'
  ClientId = '1000.15S25B602CISR5WO9RUZ8UT39O3RIH'
  ClientSecret = '9ea302935eb150d9d6cbefd35b1eb8891332d815b8'
}

$ZohoAuth = New-ZohoAccessToken @NewTokenParams
```

Request and store the access token in the local secret store:

```powershell
Request-ZohoAccessToken -Verbose
```

Module functions will retrieve the access token from the store as needed, so it doesn't need to be specified:

```powershell
$RequestParams = @{
    Status = 'Open', 'Onhold'
    Portal = 'is'
    Technician = 'devynspencer@users.noreply.github.com'
}

$Tickets = Find-ServiceDeskRequest @RequestParams
```

### Default Parameters

PowerShell allows you to save default values for parameters via the [PSDefaultParameterValues](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parameters_default_values) variable.

Add defaults to your PowerShell profile to limit the number of parameters that need to be specified when executing `ServiceDeskPlusCloud` functions:

```powershell
# Microsoft.PowerShell_Profile.ps1

$PSDefaultParameterValues['*-ServiceDeskPlus*:Portal'] = 'is'
$PSDefaultParameterValues['Find-ServiceDeskPlusRequest:Technician'] = 'devynspencer@users.noreply.github.com'
```

## Testing
First install the [Pester](https://github.com/pester/Pester) module:

```powershell
Install-Module Pester -Force
```

You're ready to run Pester tests:

```powershell
Invoke-Pester
```


## Environment Variables

Some parts of this module assume the use of environment variables for the storage of sensitive
"secrets" like account names or API tokens.

Specifically, be sure to either set the following environment variables or update the
configurations accordingly:








