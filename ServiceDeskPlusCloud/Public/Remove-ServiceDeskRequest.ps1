. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"

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
            $RestMethodParameters = @{
                Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$RequestId"
                Headers = Format-ZohoHeader
                Method = 'Delete'
            }

            Invoke-RestMethod @RestMethodParameters
        }
    }
}
