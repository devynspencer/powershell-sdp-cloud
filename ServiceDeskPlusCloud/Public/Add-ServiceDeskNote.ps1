. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Add a note to a ServiceDesk Plus resource.

.PARAMETER Id
    The id of the ServiceDesk Plus resource.

.PARAMETER Message
    The message to include in the note.

.PARAMETER Notify
    Which contacts to notify of the added note.

.PARAMETER Resource
    The type of resource to add the note to.

.PARAMETER Notify
    Which contacts to notify of the added note. Only applicable to request notes.

.EXAMPLE
    Add-ServiceDeskNote -Id 123456 -Message "Encountered problem x." -Resource requests
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

        [ValidateSet('Technician', 'Requester')]
        [string[]]
        $Notify = @()
    )

    begin {
        $Data = @{}

        # Name of the note data object depends on resource type.
        switch ($Resource) {
            'requests' {
                $Data.request_note = @{
                    description = $Message
                    notify_technician = $false
                    show_to_requester = $false
                }

                # Update notification settins for the note
                if ($Notify -contains 'Technician') {
                    $Data.request_note.notify_technician = $true
                }

                if ($Notify -contains 'Requester') {
                    $Data.request_note.show_to_requester = $true
                }
            }

            # Other resource types use the same object for note data.
            default {
                $Data.note = @{
                    description = $Message
                }

                # TODO: Handle communication params
            }
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
