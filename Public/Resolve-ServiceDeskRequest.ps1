. "$PSScriptRoot\Set-ServiceDeskRequest"

function Resolve-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Id,

        [ValidateNotNull()]
        $Message = "Work complete, resolving ticket. Respond to reopen ticket."
    )

    begin {
        $SetParams = @{
            AccessToken = $AccessToken
            Portal = $Portal
            Resolution = $Message
            Status = "Resolved"
        }
    }

    process {
        foreach ($RequestId in $Id) {
            Set-ServiceDeskRequest @SetParams -Id $RequestId
        }
    }
}