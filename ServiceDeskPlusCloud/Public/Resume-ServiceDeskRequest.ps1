. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Resume-ServiceDeskRequest {
    param (
        # Id of the request to suspend
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        # Status to set when the request is resumed
        [Alias('ResumeStatus')]
        $Status = 'Open'
    )

    begin {
        $Data = @{
            request = @{
                status = @{
                    name = $Status
                }
            }
        }
    }

    process {
        foreach ($RequestId in $Id) {
            # Build the request parameters
            $InvokeParams = @{
                Method = 'Put'
                Operation = 'Update'
                Id = $RequestId
                Data = $Data
            }

            # Make the API request
            $Response = Invoke-ServiceDeskApi @InvokeParams

            $Response
        }
    }
}
