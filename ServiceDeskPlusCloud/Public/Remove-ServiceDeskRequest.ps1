. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Remove a ServiceDesk Plus request by id.

.PARAMETER Id
    The id of the ServiceDesk Plus request.

.EXAMPLE
    Remove-ServiceDeskRequest -Id 123456
    Remove request with id 123456.
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
