. "$PSScriptRoot\Set-ServiceDeskRequest"

<#
.SYNOPSIS
    Close a ServiceDesk Plus request.

.PARAMETER Portal
    The portal for the ServiceDesk Plus Cloud instance.

.PARAMETER Id
    The id of the ServiceDesk Plus request.

.PARAMETER Message
    The message to include in the resolution of the request.

.EXAMPLE
    Close-ServiceDeskRequest -Portal portalname -Id 123456
    Close request 123456 in the specified ServiceDesk Plus Cloud instance.
#>

function Close-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        [ValidateNotNull()]
        $Message = 'Work complete, resolving ticket. Respond to reopen ticket.'
    )

    begin {
        $SetParams = @{
            Portal = $Portal
            Resolution = $Message
            Status = 'Resolved'
        }
    }

    process {
        foreach ($RequestId in $Id) {
            Set-ServiceDeskRequest @SetParams -Id $RequestId
        }
    }
}
