<#
.SYNOPSIS
    Generate a ServiceDesk Plus request based on operation.

.PARAMETER Portal
    The portal for the ServiceDesk Plus Cloud instance.
#>

function New-ServiceDeskUri {
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
        $ApiVersion = 'v3'
    )

    # Build the endpoint URI
    $Uri = switch -regex ($Operation) {
        # List or create a type of resource
        '^(List|New)$' {
            "https://sdpondemand.manageengine.com/app/$Portal/api/$ApiVersion/$Resource"
        }

        # Get or modify an existing resource
        '^(Get|Update|Remove)$' {
            if (!$PSBoundParameters.ContainsKey('Id')) {
                throw "[Id] required when performing $($Switch.Current) operations"
            }

            "https://sdpondemand.manageengine.com/app/$Portal/api/$ApiVersion/$Resource/$Id"
        }

        # List or create a type of child resource attached to an existing resource
        '^(ListChild|AddChild)$' {
            if (!$PSBoundParameters.ContainsKey('Id')) {
                throw "[Id] required when performing $($Switch.Current) operations"
            }

            if (!$PSBoundParameters.ContainsKey('ChildResource')) {
                throw "[ChildResource] required when performing $($Switch.Current) operations"
            }

            "https://sdpondemand.manageengine.com/app/$Portal/api/$ApiVersion/$Resource/$Id/$ChildResource"
        }

        # Get or modify an existing child resource attached to an existing resource
        '^(GetChild|UpdateChild|RemoveChild)$' {
            if (!$PSBoundParameters.ContainsKey('Id')) {
                throw "[Id] required when performing $($Switch.Current) operations"
            }

            if (!$PSBoundParameters.ContainsKey('ChildResource')) {
                throw "[ChildResource] required when performing $($Switch.Current) operations"
            }

            if (!$PSBoundParameters.ContainsKey('ChildId')) {
                throw "[ChildId] required when performing $($Switch.Current) operations"
            }

            "https://sdpondemand.manageengine.com/app/$Portal/api/$ApiVersion/$Resource/$Id/$ChildResource/$ChildId"
        }
    }

    Write-Verbose "API URI built for operation [$Operation]: $Uri"

    $Uri
}
