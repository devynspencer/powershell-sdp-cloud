. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"
. "$PSScriptRoot\..\private\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Find a ServiceDesk Plus request based on specified criteria.

.PARAMETER Portal
    The portal for the ServiceDesk Plus Cloud instance.

.PARAMETER Status
    Request status to filter results by.

.PARAMETER Technician
    Request technician to filter results by.

.PARAMETER Fields
    Request fields to include in results.

.EXAMPLE
    Find-ServiceDeskRequest -Portal portalname -Technician foo.bar@example.com
    Return requests owned by the specified technician.
#>

function Find-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $Portal,

        [ValidateNotNull()]
        [string[]]
        $Status = 'Open',

        [ValidateNotNull()]
        $Technician,

        # Maximum number of requests to return. Value passed to the row_count property of the
        # list_info object passed to the API
        $Limit = 100,

        # Skip n requests, useful for pagination. Value passed to the start_index property of the
        # list_info object passed to the API
        $StartIndex,

        # TODO: Separate these into different parameter sets, **defaulting to Page for now**
        $Page = 1
    )

    $ApiParams = @{
        Portal = $Portal
        Resource = 'requests'
        Limit = $Limit
        Page = $Page
    }

    $Response = Invoke-ServiceDeskApi @ApiParams

    $Response
}
