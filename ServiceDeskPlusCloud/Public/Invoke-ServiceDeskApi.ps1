. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"

function Invoke-ServiceDeskApi {
    param (
        # URI to the ServiceDesk Plus cloud server, i.e. https://sdp.example.com
        # [Parameter(Mandatory)]
        $BaseUri = (Get-Secret -Vault Zoho -AsPlainText -Name 'BASE_URI'),

        # The HTTP method to use for the operation, based on the ServiceDesk Plus cloud API documentation.
        [ValidateSet('Get', 'Post', 'Put', 'Delete')]
        $Method = 'Get',

        # The ServiceDesk Plus cloud portal name for the request.
        [ValidateNotNullOrEmpty()]
        [string]
        $Portal = (Get-Secret -Vault Zoho -AsPlainText -Name 'PORTAL_NAME'),

        # The API operation to perform. Determines structure of request URI, as well as required parameters.
        [Parameter(Mandatory)]
        [ValidateSet(
            'Get',
            'List',
            'New',
            'Update',
            'Remove',
            'GetChild',
            'ListChild',
            'AddChild',
            'UpdateChild',
            'RemoveChild'
        )]
        $Operation,

        # The base resource type to operate on. Determines structure of request URI, as well as acceptable child resources (if applicable).
        [Parameter(Mandatory)]
        [ValidateSet(
            'requests',
            'problems',
            'assets',
            'projects',
            'changes',
            'tasks',
            'solutions',
            'topics'
        )]
        $Resource,

        # The Id of an existing resource to operate on (if applicable). Required for operations on a specific resource, i.e. Get/Update/Remove, as well as any child resource operation.
        [string]
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
        [string]
        $ChildId,

        # Behavior to use when response indicates that more records are available,
        # i.e. { "list_info": { "has_more_rows": true, ... } }
        #
        # - Continue: Always request the next page of resources.
        # - PolitelyContinue: Request additional resources, but wait at least $PaginateDelay seconds
        #   between requests.
        # - Stop: Do not request additional resources.
        #
        [ValidateSet('Continue', 'Stop', 'PolitelyContinue')]
        $PaginateAction = 'PolitelyContinue',

        # Number of seconds to wait between paginated requests. Polite clients will always wait at
        # least n seconds between requests.
        [ValidateRange(1, 30)]
        $PaginateDelay = 5,

        # Maximum number of requests to return. Value passed to the row_count property of the
        # list_info object passed to the API
        $Limit = 100,

        # Skip n requests, useful for pagination. Value passed to the start_index property of the
        # list_info object passed to the API
        $StartIndex = 1,

        # TODO: Separate these into different parameter sets, **defaulting to Page for now**
        # Results page to start from
        $Page = 1
    )

    # Attempt to identify if this was called recursively
    if ((Get-PSCallStack)[1].Command -eq $MyInvocation.MyCommand) {
        Write-Warning 'Function has same name as calling function. Likely recursive.'
    }

    # Strip protocol/scheme prefix from BaseUri to ensure RequestUri doesn't end up with "https://https://sdp.example.com" or similar.
    $BaseUri = $BaseUri -replace 'https://' -replace '/api/v3/'

    # Construct request URI based on the provided parameters
    # Note: $Portal is no longer used apparently
    $RequestUri = "https://$BaseUri/api/v3/$Resource"

    if ($PSBoundParameters.ContainsKey('Id')) {
        $RequestUri += "/$Id"
    }

    if ($PSBoundParameters.ContainsKey('ChildResource')) {
        $RequestUri += "/$ChildResource"
    }

    if ($PSBoundParameters.ContainsKey('ChildId')) {
        $RequestUri += "/$ChildId"
    }

    Write-Verbose "[Invoke-ServiceDeskApi] URI constructed!`n$(ConvertTo-Json @{ BaseUri = $BaseUri; RequestUri = $RequestUri })"

    # Construct request body
    #
    # Note: Invoke-RestMethod takes quite a few liberties with how this is used, depending on the request method used (see GET vs POST specifically).
    # From the documentation (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod):
    #
    # The Body parameter can be used to specify a list of query parameters or specify the content of the response.
    #
    # When the input is a POST request and the body is a String, the value to the left of the first equals sign (=) is set as a key in the form data and the remaining text is set as the value. To specify multiple keys, use an IDictionary object, such as a hash table, for the Body.
    #
    # When the input is a GET request and the body is an IDictionary (typically, a hash table), the body is added to the URI as query parameters. For other request types (such as PATCH), the body is set as the value of the request body in the standard name=value format with the values URL-encoded.

    # For navigating and getting data, list_info can be provided with input_data. list_info object must be used as parameters for the requesting URL not as form data. list_info object should be encoded. list_info object can only be used for get all(get list).

    # Note the types for the below! The **value** of input_data must be a JSON string.
    $Body = @{
        input_data = @{} # value is JSON object
    }

    # TODO: Move Body from InvokeRestParams.Body to standalone variable (easier if pagination actions require more API calls)

    # Build the request parameters
    $InvokeRestParams = @{
        Uri = $RequestUri
        Method = $Method # TODO: Determine request method to use based on context
        Headers = (Format-ZohoHeader -Portal $Portal)
        Verbose = $true
    }

    # Add pagination parameters to request body (if supported for request)
    if ($Operation -in @('List', 'ListChild')) {
        $Body.input_data.list_info = @{}
        $Body.input_data.list_info.start_index = $StartIndex
        $Body.input_data.list_info.page = $Page
        $Body.input_data.list_info.row_count = $Limit

        Write-Verbose "[Invoke-ServiceDeskApi] Multiple resources requested, including pagination parameters:`n$(ConvertTo-Json $InvokeRestParams.Body)"
    }

    else {
        Write-Verbose '[Invoke-ServiceDeskApi] Not requesting multiple resources, skipping pagination'
    }

    # Format request body, based on cryptic instructions from ManageEngine documentation
    $InvokeRestParams.Body = @{ input_data = (ConvertTo-Json $Body.input_data -Compress -Depth 4) };

    Write-Verbose "[Invoke-ServiceDeskApi] Making API call to [$($InvokeRestParams.Uri)] using method [$($InvokeRestParams.Method)] with body:`n$(ConvertTo-Json $InvokeRestParams.Body)"


    # Perform the API call using the constructed request URI
    $Response = Invoke-RestMethod @InvokeRestParams

    # Cache results while handling pagination
    $Results = @($Response."$Resource")

    do {
        # Increment pagination counter and previous response for reference
        $Page += 1
        $Previous = $Response

        Write-Verbose "[Invoke-ServiceDeskApi] More resources are available! Pagination behavior is [$PaginateAction]..."
        Write-Verbose "[Invoke-ServiceDeskApi] Continuing on page [$Page] ..."

        # Rebuild body for next API call
        $Body = @{ input_data = @{} }
        $Body.input_data.list_info = @{}
        $Body.input_data.list_info.page = $Page
        $Body.input_data.list_info.row_count = $Limit

        # Format input data payload and add to request body
        $InvokeRestParams.Body = @{ input_data = (ConvertTo-Json $Body.input_data -Compress -Depth 4) };

        # Apply selected paginate action to results
        switch ($PaginateAction) {
            'Continue' {
                Write-Verbose '[Invoke-ServiceDeskApi] PaginateAction set to [Continue]. Requesting next page ...'

                $Response = Invoke-RestMethod @InvokeRestParams
                $Results += $Response."$Resource"

                Write-Verbose "[Invoke-ServiceDeskApi] Pagination: [$($Response.list_info)]"
            }

            'PolitelyContinue' {
                Write-Verbose "[Invoke-ServiceDeskApi] PaginateAction set to [ContinuePolitely]. Waiting [$PaginateDelay] seconds before requesting next page ..."

                Start-Sleep -Seconds $PaginateDelay
                $Response = Invoke-RestMethod @InvokeRestParams
                $Results += $Response."$Resource"

                Write-Verbose "[Invoke-ServiceDeskApi] Pagination: [$($Response.list_info)]"
            }

            'Stop' {
                Write-Verbose '[Invoke-ServiceDeskApi] PaginateAction set to [Stop]. Skipping additional records ...'
                break
            }
        }
    }

    until (!$Response.list_info.has_more_rows)

    # Return array of paginated results
    $Results
}
