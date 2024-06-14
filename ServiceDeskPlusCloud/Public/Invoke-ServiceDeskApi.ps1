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

        # Additional parameters for the request. Examples: mesage body of a note to add, details of a new change request
        $Data,

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

        # TODO: Format resource names as plural/singular (to help identify the field name for resource data and similar)
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

        # TODO: Format resource names as plural/singular (to help identify the field name for resource data and similar)
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

        # Maximum number of total requests to attempt in a given execution. Intended to avoid an endless
        # loop of requests when paginating multiple resources, or building out new queries.
        $PageLimit = 10,

        # Maximum number of requests to return. Value passed to the row_count property of the
        # list_info object passed to the API
        $Limit = 100,

        # Skip n requests, useful for pagination. Value passed to the start_index property of the
        # list_info object passed to the API
        $StartIndex = 1,

        # TODO: Separate these into different parameter sets, **defaulting to Page for now**
        # Results page to start from
        $Page = 1,

        # Field to sort results by, i.e. "created_time"
        $SortField,

        # Whether to sort in ascending or descing order
        [ValidateSet('asc', 'desc')]
        $SortOrder
    )

    Write-Verbose "[Invoke-ServiceDeskApi] Preparing API request => [$Operation] on [$Resource] page [$Page]"

    # Attempt to identify if this was called recursively
    if ((Get-PSCallStack)[1].Command -eq $MyInvocation.MyCommand) {
        Write-Warning 'Function has same name as calling function. Likely recursive.'
    }

    # Strip protocol/scheme prefix from BaseUri to ensure RequestUri doesn't end up with "https://https://sdp.example.com" or similar.
    $BaseUri = $BaseUri -replace 'https://' -replace '/api/v3/'

    # Construct request URI based on the provided parameters
    # Note: $Portal is no longer used apparently
    $RequestUri = "https://$BaseUri/api/v3/$Resource"

    Write-Verbose "[Invoke-ServiceDeskApi] Base URI: $BaseUri"

    if ($PSBoundParameters.ContainsKey('Id')) {
        $RequestUri += "/$Id"
    }

    Write-Verbose "[Invoke-ServiceDeskApi] Request URI: $RequestUri"

    if ($PSBoundParameters.ContainsKey('ChildResource')) {
        $RequestUri += "/$ChildResource"
    }

    if ($PSBoundParameters.ContainsKey('ChildId')) {
        $RequestUri += "/$ChildId"
    }

    Write-Verbose "[Invoke-ServiceDeskApi] Request URI after appending child resource path: $RequestUri"

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

    if ($PSBoundParameters.ContainsKey('Data')) {
        Write-Verbose "[Invoke-ServiceDeskApi] adding specified data to payload:`n$(ConvertTo-Json -Compress $Data)"
        $Body.input_data += $Data
    }

    # TODO: Move Body from InvokeRestParams.Body to standalone variable (easier if pagination actions require more API calls)

    # Build the request parameters
    $InvokeRestParams = @{
        Uri = $RequestUri
        Method = $Method # TODO: Determine request method to use based on context
        Verbose = $true
        Headers = (Format-ZohoHeader)
    }

    # Add pagination parameters to request body (if supported for request)
    if ($Operation -in @('List', 'ListChild')) {
        $Body.input_data.list_info = @{}

        # Add pagination parameters to request body
        $Body.input_data.list_info.start_index = $StartIndex
        $Body.input_data.list_info.page = $Page
        $Body.input_data.list_info.row_count = $Limit

        # Add sorting parameters to request body
        if ($PSBoundParameters.ContainsKey('SortField')) {
            $Body.input_data.list_info.sort_field = $SortField
        }

        if ($PSBoundParameters.ContainsKey('SortOrder')) {
            $Body.input_data.list_info.sort_order = $SortOrder
        }

        Write-Verbose "[Invoke-ServiceDeskApi] Operation [$Operation] supports pagination! Behavior is [$PaginateAction]"
    }

    # Format request body, based on cryptic instructions from ManageEngine documentation
    $InvokeRestParams.Body = @{ input_data = (ConvertTo-Json $Body.input_data -Compress -Depth 4) }

    Write-Verbose "[Invoke-ServiceDeskApi] Sending $Method request to [$($InvokeRestParams.Uri)] with payload: $($InvokeRestParams.Body.input_data)"

    # Perform the API call using the constructed request URI
    $Response = Invoke-RestMethod @InvokeRestParams

    # Cache results while handling pagination
    # TODO: This doesn't apply when using ListChild and no child resources are found, for example the following follows the "else" and (incorrectly) returns the full response (including response_status, list_info, *and* the empty tasks array):
    #
    #   Invoke-ServiceDeskApi -Verbose -Method Get -Portal isservicedesk -Resource requests -BaseUri https://sdp.oya.state.or.us -Operation ListChild -Id 118870000020103167 -ChildResource tasks -Limit 2
    # Using ContainsKey to ensure cases where no child resources exist are handled the same

    # TODO: Move to separate function, as this is a lot of logic for a single function

    # TODO: This seems more optimistic than cautious. One inconsistently named resource and it's broken
    # i.e. api/v3/unicorn instead of api/v3/unicorns
    # TODO: Need to factor in whether a ChildResource was specified, as in that case the response object
    #   won't contain a property named "$Resource" (or "$SingleResource" either, as currently written),
    #   the property should then match "$ChildResource" (or the singular resource name)

    # Determine expected property name from response object, based on operation type. For example, the
    # response to a "List" operation for "requests" should contain a "requests" property. Conversely,
    # a response to a "ListChild" operation should contain the plural form of the child resource name.
    #
    # Finally, the response to a "Get" or "GetChild" operation then would be expected to contain the
    # singular form of the parent or child resource name, respectively.
    $ResponsePropertyName = switch ($Operation) {
        'Get' {
            $Resource -replace 's$' # Singular form of resource name
        }
        'List' {
            $Resource # Plural form of resource name
        }
        'New' {
            $Resource -replace 's$' # Singular form of resource name
        }
        'Update' {
            $Resource -replace 's$' # Singular form of resource name
        }
        'Remove' {
            # Assuming a Remove operation returns anything?
            $Resource -replace 's$' # Singular form of resource name
        }
        'GetChild' {
            $ChildResource -replace 's$' # Singular form of child resource name
        }
        'ListChild' {
            $ChildResource # Plural form of child resource name
        }
        'AddChild' {
            $ChildResource -replace 's$' # Singular form of child resource name
        }
        'UpdateChild' {
            $ChildResource -replace 's$' # Singular form of child resource name
        }
        'RemoveChild' {
            # Assuming a RemoveChild operation returns anything?
            $ChildResource -replace 's$' # Singular form of child resource name
        }
    }

    $PropertyNames = (Get-Member -MemberType NoteProperty -InputObject $Response).Name | sort
    Write-Verbose "[Invoke-ServiceDeskApi] Expecting property [$ResponsePropertyName] in response object. Found [$($PropertyNames.Count)] properties: $($PropertyNames -join ', ')"

    # Extract resource(s) from response based on expected property name
    if ($Response."$ResponsePropertyName") {
        # TODO: Include id of parent resource with each child resource (ParentId) -- maybe other useful properties describing the parent?
        $Results = @($Response."$ResponsePropertyName")
        Write-Verbose "[Invoke-ServiceDeskApi] Expected property [$ResponsePropertyName] found!"
    }

    # Handle responses that contain expected property, but property is empty
    elseif ($Response."$ResponsePropertyName".count -eq 0) {
        Write-Verbose "[Invoke-ServiceDeskApi] Expected property [$ResponsePropertyName] found, but contains no resource! This is likely a ListChild operation on a resource without any of that child resource."
    }

    # The response should never be empty, so if the above aren't true then something is wrong
    else {
        throw "Expected response object to contain [$ResponsePropertyName]:`n`n$(ConvertTo-Json $Response -Compress)`n`n$Error"
    }

    # TODO: Cleanup pagination verbose statements below - replace with 1-2 statements for "More .. available" and maybe "Paginate action is [...] ..." **and then** explain what is happening specific to each case

    # Handle pagination and request remaining pages
    if ($Response.list_info -and $Response.list_info.has_more_rows) {
        # Check if current page is over value specified in PageLimit
        if ($Page -gt $PageLimit) {
            Write-Verbose "[Invoke-ServiceDeskApi] Maximum number of requests reached ($PageLimit)! Stopping pagination after $($Page - 1) pages ..."
            Write-Verbose "[Invoke-ServiceDeskApi] This is a client-side behavior to avoid an endless loop of pagination attempts. The limit can be changed via the PageLimit parameter (currently $PageLimit)."
            break
        }

        # Increment current page number and check if specified page limit has been reached
        $Page += 1

        # Reuse bound parameters from original function call, updating anything changed during pagination
        # TODO: Ensure this is a *deep* copy
        # TODO: Identify original vs. recursive function calls somehow
        $InvokeParams = $PSBoundParameters
        $InvokeParams['Page'] = $Page

        # Handle pagination based on specified behavior
        switch ($PaginateAction) {
            'Continue' {
                Write-Verbose "[Invoke-ServiceDeskApi] More resources are available! Executing new request on page $Page ..."

                $Response = Invoke-ServiceDeskApi @InvokeParams
                $Results += $Response

                Write-Verbose "[Invoke-ServiceDeskApi] Added [$($Response.Count)] resources from page $Page to results."
            }

            'PolitelyContinue' {
                Write-Verbose "[Invoke-ServiceDeskApi] More resources are available! Executing new request on page $Page in $PaginateDelay seconds ..."

                Start-Sleep -Seconds $PaginateDelay
                $Response = Invoke-ServiceDeskApi @InvokeParams
                $Results += $Response

                Write-Verbose "[Invoke-ServiceDeskApi] Added [$($Response.Count)] resources from page $Page to results."
            }

            # TODO: Why is this called Stop instead of Skip or Ignore etc?
            'Stop' {
                Write-Verbose '[Invoke-ServiceDeskApi] More resources are available, but will be skipped due to PaginateAction.'
                break
            }
        }
    }

    # TODO: Format property names using ConvertTo-PascalCase or similar. The Zoho properties are gross

    # Return array of all results
    Write-Verbose "[Invoke-ServiceDeskApi] Returning [$($Results.Count)] $ResponsePropertyName, in total"
    $Results
}
