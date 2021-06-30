# PowerShell: ServiceDeskPlusCloud
Module for interacting with the ManageEngine ServiceDeskPlus OnDemand API


## Getting Started
In order to obtain a temporary authorization code to authenticate to the API with, you first need to register a self-client application via the [ZOHO API Client Console](https://api-console.zoho.com/). See the [ManageEngine API documentation](https://www.manageengine.com/products/service-desk/sdpod-v3-api/SDPOD-V3-API.html#authorization-request) for the full documentation on registration.

Follow the steps in the documentation to generate a temporary authentication code and supply the value to the `GrantToken` parameter of `New-ZohoAccessToken` or download the `self_client.json` file from the API client console and supply the path via the `FilePath` parameter.

Using the `self_client.json` file:

```powershell
$LatestAuthFile = (Get-ChildItem -Path '~\Downloads\self_client*.json' | sort LastWriteTime -Descending)[0]

$ZohoAuth = New-ZohoAccessToken -FilePath $LatestAuthFile
```

Or by specifying your credentials as parameters:

```powershell
$NewTokenParams = @{
  GrantToken = '1000.f74e7b6fc16c95bbc1fa2f067962f84b.9768e796b6273774817032613ba6892a'
  ClientId = '1000.15S25B602CISR5WO9RUZ8UT39O3RIH'
  ClientSecret = '9ea302935eb150d9d6cbefd35b1eb8891332d815b8'
}

$ZohoAuth = New-ZohoAccessToken @NewTokenParams
```

Then use the token to interact with the API:

```powershell
$RequestParams = @{
    Status = 'Open', 'Onhold'
    Portal = 'is'
    Technician = 'devynspencer@users.noreply.github.com'
    AccessToken = $ZohoAuth.access_token
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
