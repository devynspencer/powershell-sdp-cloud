. "$PSScriptRoot\Set-ServiceDeskRequest"

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
