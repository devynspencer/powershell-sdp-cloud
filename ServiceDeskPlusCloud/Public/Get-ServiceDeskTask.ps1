. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Get-ServiceDeskTask {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )

    process {
        foreach ($RequestId in $Id) {
            $InvokeParams = @{
                Method = 'Get'
                Operation = 'Get'
                Resource = 'tasks'
                Id = $RequestId
            }

            $Response = Invoke-ServiceDeskApi @InvokeParams

            $Response
        }
    }
}
