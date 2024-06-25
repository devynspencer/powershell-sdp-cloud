. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Get a ServiceDesk Plus request by id.

.PARAMETER Id
    The id of the ServiceDesk Plus request.

.EXAMPLE
    Get-ServiceDeskRequest -Portal portalname -Id 123456
    Get request with id 123456.
#>

function Get-ServiceDeskRequest {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )

    process {
        foreach ($RequestId in $Id) {
            $RestMethodParameters = @{
                Method = 'Get'
                Operation = 'Get'
                Resource = 'requests'
                Id = $RequestId
            }

            $Response = Invoke-ServiceDeskApi @RestMethodParameters

            $Response
        }
    }
}
