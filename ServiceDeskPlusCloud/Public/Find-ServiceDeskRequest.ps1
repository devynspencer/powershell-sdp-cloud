. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"
. "$PSScriptRoot\..\private\Format-ZohoSearch.ps1"

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

        # Do not include the total request count in response object. Value passed to the get_total_count
        # property of the list_info object passed to the API
        [switch]
        $NoTotalCount
    )

    # Build search object from PSBoundParameters to avoid a parade of
    # statements like `if ($PSBoundParameters.ContainsKey("Foo")) { ... }`
    $SearchParams = $PSBoundParameters
    $SearchParams.Remove('Portal')

    # Build input data object
    $Data = @{
        list_info = @{
            search_criteria = Format-ZohoSearch @SearchParams
            row_count = $Limit
        }
    }

    # Handle total item count, if switch present
    if (!$NoTotalCount) {
        $Data.list_info.get_total_count = $true
    }

    $Body = @{
        input_data = ($Data | ConvertTo-Json -Depth 4 -Compress)
    }

    # Send the request
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
