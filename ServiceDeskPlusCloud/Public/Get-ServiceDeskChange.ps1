. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Get a ServiceDesk Plus change by id.

.PARAMETER Id
    The id of the ServiceDesk Plus change.

.EXAMPLE
    Get-ServiceDeskChange -Id 123456
    Get change with id 123456.
#>

function Get-ServiceDeskChange {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )

    process {
        foreach ($ResourceId in $Id) {
            $RequestParams = @{
                Method = 'Get'
                Operation = 'Get'
                Resource = 'changes'
                Id = $ResourceId
                Verbose = $true
            }

            $Response = Invoke-ServiceDeskApi @RequestParams

            $Response
        }
    }
}
