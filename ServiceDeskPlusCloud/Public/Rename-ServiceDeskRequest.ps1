. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Rename-ServiceDeskRequest {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        [Parameter(Mandatory)]
        $Subject
    )

    begin {
        $Data = @{
            request = @{ subject = $Subject }
        }
    }

    process {
        foreach ($RequestId in $Id) {
            # Build the API parameters
            $InvokeParams = @{
                Method = 'Put'
                Operation = 'Update'
                Resource = 'requests'
                Id = $RequestId
                Data = $Data
            }

            # Make the API call
            $Response = Invoke-ServiceDeskApi @InvokeParams

            $Response
        }
    }
}
