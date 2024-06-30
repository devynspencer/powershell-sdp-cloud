. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Get-ServiceDeskTask {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )

    process {
        foreach ($ResourceId in $Id) {
            $InvokeParams = @{
                Method = 'Get'
                Operation = 'Get'
                Resource = 'tasks'
                Id = $ResourceId
            }

            $Response = Invoke-ServiceDeskApi @InvokeParams

            $Response
        }
    }
}
