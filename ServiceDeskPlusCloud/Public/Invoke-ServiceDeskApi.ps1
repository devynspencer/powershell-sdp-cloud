. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"

function Invoke-ServiceDeskApi {
    param (
        # URI to the ServiceDesk Plus cloud server, i.e. https://sdp.example.com
        [Parameter(Mandatory)]
        $BaseUri,

        # The HTTP method to use for the operation, based on the ServiceDesk Plus cloud API documentation.
        [ValidateSet('Get', 'Post', 'Put', 'Delete')]
        $Method = 'Get',

        # The ServiceDesk Plus cloud portal name for the request.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Portal,

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
        $ChildId
    )

    # Strip protocol/scheme prefix from BaseUri to ensure RequestUri doesn't end up with "https://https://sdp.example.com" or similar.
    $BaseUri = $BaseUri -replace 'https://' -replace '/api/v3/'

    # Construct request URI based on the provided parameters
    # Note: $Portal is no longer used apparently
    $RequestUri = "https://$BaseUri/api/v3/$Resource"s

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

    $Body = @{
        input_data = @{}
    }

    Write-Verbose "[Invoke-ServiceDeskApi] Making API call to [$RequestUri] using method [$Method] with body:`n$(ConvertTo-Json -InputObject $Body)"

    # Build the request parameters
    $InvokeRestParams = @{
        Uri = $RequestUri
        Method = $Method # TODO: Determine request method to use based on context
        Headers = (Format-ZohoHeader -Portal $Portal)
        Body = (ConvertTo-Json $Body)
    }

    # Perform the API call using the constructed request URI
    $Response = Invoke-RestMethod @InvokeRestParams

    # Return the API response
    $Response
}
