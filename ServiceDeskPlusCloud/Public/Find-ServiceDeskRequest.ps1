. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"

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
        # $StartIndex = 1,
        $StartIndex,

        # TODO: Separate these into different parameter sets, **defaulting to Page for now**
        $Page = 1
    )

    # Build input data object
    $Data = @{
        list_info = @{
            row_count = $Limit
        }
    }

    if ($PSBoundParameters.ContainsKey('StartIndex')) {
        $Data.list_info.start_index = $StartIndex
    # TODO: Handle NoTotalCount?
    }

    if ($PSBoundParameters.ContainsKey('Page')) {
        $Data.list_info.page = $Page
    }


    $Body = @{
        input_data = ($Data | ConvertTo-Json -Depth 4 -Compress)
    }

    # TODO: Move this to a function that builds each request
    # Send the request
    Write-Verbose "Sending request with body:`n$($Body.input_data)"

    $RestMethodParameters = @{
        Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests"
        Headers = Format-ZohoHeader
        Method = 'Get'
        Body = $Body
    }

    $Response = Invoke-RestMethod @RestMethodParameters

    $Response

    # TODO: Include error codes, metadata, and pagination info in response
    # TODO: Add error handling based on error code

    # Handle the response

    # Format the response object
}
