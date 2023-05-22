. "$PSScriptRoot\Format-ZohoHeader.ps1"

<#
.SYNOPSIS
    Find a ServiceDesk Plus request based on specified criteria.

.PARAMETER Portal
    The portal for the ServiceDesk Plus Cloud instance.
#>

function Invoke-ServiceDeskApi {
    # TODO: Validate length and pattern of id parameters? Must be text to allow for leading 0's.

    # TODO: Would parameter sets based on each operation/group of similar operations be cleaner?

    param (
        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory)]
        [ValidateSet('Get', 'List', 'New', 'Update', 'Remove')]
        $Operation,

        # Resource type to operate on.
        [Parameter(Mandatory)]
        [ValidateSet('requests', 'problems', 'assets', 'projects', 'changes', 'tasks', 'solutions', 'topics')]
        $Resource,

        # Id of an existing resource to operate on.
        $Id,

        $ApiVersion = 'v3',

        [ValidateSet('Get', 'Post', 'Put', 'Patch', 'Delete')]
        $Method = 'Get',

        # TODO: Add search criteria
        # $Search = @{}

        # TODO: Add Fields parameter to restrict fields in returned object (using input_data)

        # TODO: Add parameter for search criteria

        # Maximum number of requests to return. Value passed to the row_count property of the
        # list_info object passed to the API
        $Limit = 100,

        # Skip n requests, useful for pagination. Value passed to the start_index property of the
        # list_info object passed to the API
        $StartIndex,

        # TODO: Separate these into different parameter sets, **defaulting to Page for now**
        $Page = 1,

        # Do not include the total request count in response object. Value passed to the get_total_count
        # property of the list_info object passed to the API
        [switch]
        $NoTotalCount
    )

    # Build input_data object with basic pagination parameters
    $Data = @{
        list_info = @{
            row_count = $Limit
        }
    }

    # Add pagination parameters to input_data object
    if ($PSBoundParameters.ContainsKey('StartIndex')) {
        $Data.list_info.start_index = $StartIndex
    }

    if ($PSBoundParameters.ContainsKey('Page')) {
        $Data.list_info.page = $Page
    }

    if (!$NoTotalCount) {
        $Data.list_info.get_total_count = $true
    }

    # Build request body as JSON
    $Body = @{
        input_data = ($Data | ConvertTo-Json -Compress)
    }

    Write-Verbose "Sending request with body:`n$($Body.input_data)"

    # Build the endpoint URI

    # Make the request
    $RestMethodParameters = @{
        Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/$ApiVersion/$Resource"
        Headers = Format-ZohoHeader
        Method = $Method
        Body = $Body
    }

    Write-Verbose "Making request $($RestMethodParameters | ConvertTo-Json -Compress)"

    $Response = Invoke-RestMethod @RestMethodParameters -Verbose -ContentType 'application/x-www-form-urlencoded'

    # TODO: Add error handling based on error code
    if ([int] $Response.response_status.status_code -ne 2000) {
        Write-Error "Request failed with status code $($Response.response_status)"
        # Handle specific error codes or implement custom logic here
    }

    # TODO: Include error codes, metadata, and pagination info in response

    $Response
}
