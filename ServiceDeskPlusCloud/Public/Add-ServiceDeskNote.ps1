. "$PSScriptRoot\..\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Add a note to a ServiceDesk Plus resource.

.PARAMETER Portal
    The portal for the ServiceDesk Plus Cloud instance.

.PARAMETER Id
    The id of the ServiceDesk Plus request.

.PARAMETER Message
    The message to include in the note.

.PARAMETER Notify
    Notify the requester of the added note.

.PARAMETER Public
    Display the note to all users and the requester.

.EXAMPLE
    Add-ServiceDeskNote -Portal portalname -Id 123456 -Message "Encountered problem x."
    Add a note to request 123456 in the specified ServiceDesk Plus Cloud instance.
#>

function Add-ServiceDeskNote {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $Message,

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

        [switch]
        $Notify,

        # Notify the requester.
        [switch]
        $Public
    )

    begin {
        # Build shared API parameters
        $Data = @{
            request_note = @{
                description = $Message
                notify_technician = $false
                show_to_requester = $false
            }
        }

        # Coddle switch parameters until they function as designed
        if ($Notify) {
            $Data.request_note.notify_technician = $true
        }

        if ($Public) {
            $Data.request_note.show_to_requester = $true
        }
    }

    process {
        foreach ($RequestId in $Id) {
            # Build the API parameters
            $InvokeParams = @{
                Method = 'Post'
                Operation = 'AddChild'
                ChildResource = 'notes'
                Resource = $Resource
                Id = $RequestId
                Data = $Data
            }

            # Invoke the API and return the response
            $Response = Invoke-ServiceDeskApi @InvokeParams

            $Response
        }
    }
}
