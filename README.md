# powershell-sdp-cloud
Module for interacting with the ManageEngine ServiceDeskPlus OnDemand API

## Getting Started
In order to obtain a temporary authorization code to specify in the `GrantToken` parameter of `New-ZohoAccessToken`, you first need to register an application ("self-client" in this case) as discussed in the ManageEngine API documentation [here](https://www.manageengine.com/products/service-desk/sdpod-v3-api/SDPOD-V3-API.html#authorization-request).

Follow the steps in the documentation to generate a temporary authentication code and supply the value to the `GrantToken` parameter of `New-ZohoAccessToken`.
