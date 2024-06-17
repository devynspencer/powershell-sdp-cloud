. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"

<#
.SYNOPSIS
    Add a note to a ServiceDesk Plus request.

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

        [switch]
        $Notify,

        # Notify the requester.
        [switch]
        $Public
    )

    begin {
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

        $Body = @{
            input_data = ($Data | ConvertTo-Json -Depth 4 -Compress)
        }
    }

    process {
        foreach ($RequestId in $Id) {
            $RestMethodParameters = @{
                Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$RequestId/notes"
                Headers = Format-ZohoHeader
                Method = 'Post'
                Body = $Body
            }

            $Response = (Invoke-RestMethod @RestMethodParameters).request_note

            $Note = [ordered] @{
                Id = $Response.id
                Creator = $Response.created_by.email_id
                CreatedTime = $Response.created_time.display_value
                RequestId = $Response.request.id
                RequestSubject = $Response.request.subject
                RequestDisplayId = $Response.request.display_id
                Message = $Response.description
                Public = $Response.show_to_requester
            }

            [pscustomobject] $Note
        }
    }
}
