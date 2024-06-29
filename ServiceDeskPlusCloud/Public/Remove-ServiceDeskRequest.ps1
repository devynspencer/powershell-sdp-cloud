. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Remove a ServiceDesk Plus request by id.

.PARAMETER Portal
    The portal for the ServiceDesk Plus Cloud instance.

.PARAMETER Id
    The id of the ServiceDesk Plus request.

.EXAMPLE
    Remove-ServiceDeskRequest -Portal portalname -Id 123456
    Add a note to request 123456 in the specified ServiceDesk Plus Cloud instance.
#>

function Remove-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id
    )

    process {
        foreach ($RequestId in $Id) {
            $InvokeParams = @{
                Method = 'Delete'
                Operation = 'Remove'
                Resource = 'requests'
                Id = $RequestId
            }

            $Response = Invoke-ServiceDeskApi @InvokeParams

            $Response
        }
    }
}
