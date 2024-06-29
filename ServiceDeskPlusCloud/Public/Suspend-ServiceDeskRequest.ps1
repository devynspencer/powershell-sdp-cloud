. "$PSScriptRoot\..\Private\ConvertTo-UnixTimestamp.ps1"
. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Suspend-ServiceDeskRequest {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        $Until,

        $Message
    )

    begin {
        $Data = @{
            request = @{
                status = @{
                    name = 'Onhold'
                }
            }
        }

        if ($Until) {
            $Data.request.onhold_scheduler = @{
                change_to_status = @{
                    name = 'Open'
                }

                scheduled_time = @{
                    value = ConvertTo-UnixTimestamp $Until
                }
            }

            if ($Message) {
                $Data.request.onhold_scheduler.comments = $Message
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
            $Response = Invoke-RestMethod @InvokeParams

            $Response
        }
    }
}
