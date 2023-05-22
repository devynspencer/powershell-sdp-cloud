. "$PSScriptRoot\Format-ZohoHeader.ps1"
. "$PSScriptRoot\New-ServiceDeskUri.ps1"

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
        # The ServiceDesk Plus cloud portal name for the request.
        [Parameter(Mandatory)]
        $Portal,

        # The API operation to perform. Determines structure of request URI, as well as required parameters.
        [Parameter(Mandatory)]
        [ValidateSet('Get', 'List', 'New', 'Update', 'Remove', 'GetChild', 'ListChild', 'AddChild', 'UpdateChild', 'RemoveChild')]
        $Operation,

        # The base resource type to operate on. Determines structure of request URI, as well as acceptable child resources (if applicable).
        [Parameter(Mandatory)]
        [ValidateSet('requests', 'problems', 'assets', 'projects', 'changes', 'tasks', 'solutions', 'topics')]
        $Resource,

        # The Id of an existing resource to operate on (if applicable). Required for operations on a specific resource, i.e. Get/Update/Remove, as well as any child resource operation.
        $Id,

        # The Child resource type to operate on (of applicable). Used when adding a child resource to an existing resource. Required for any child resource operation.
        #
        # Example: adding a task to a request
        #   api/v3/requests/{request_id}/tasks
        #
        [ValidateSet('tasks', 'notes', 'worklogs', 'approvals', 'relations')]
        $ChildResource,

        # The id of an existing child resource to operate on (if applicable). Required for operations on specific child resources, i.e. GetChild/UpdateChild/RemoveChild.
        #
        # Example: Edit a task attached to a request
        #   api/v3/requests/{request_id}/tasks/{task_id}
        #
        $ChildId,

        # The ServiceDesk Plus cloud API version to use for the operation. The v3 API is used for most operations, but some resources may require v2.
        [ValidateSet('v2', 'v3')]
        $ApiVersion = 'v3',

        # The HTTP method to use for the operation, based on the ServiceDesk Plus cloud API documentation.
        [ValidateSet('Get', 'Post', 'Put', 'Patch', 'Delete')]
        $Method = 'Get',

        # TODO: Add search criteria
        # Search criteria to apply to the operation (if applicable).
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

    # Build the URI endpoint parameters
    $UriParams = @{
        Portal = $Portal
        Operation = $Operation
        Resource = $Resource
        ApiVersion = $ApiVersion
    }

    # TODO: This is ugly as hell. Still unsure of an elegant way to pass these along
    if ($PSBoundParameters.ContainsKey('Id')) {
        $UriParams[$Id] = $Id
    }

    if ($PSBoundParameters.ContainsKey('ChildResource')) {
        $UriParams[$ChildResource] = $ChildResource
    }

    if ($PSBoundParameters.ContainsKey('ChildId')) {
        $UriParams[$ChildId] = $ChildId
    }

    # Make the request
    $RestMethodParameters = @{
        Uri = New-ServiceDeskUri @UriParams
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
