. "$PSScriptRoot\..\Private\ConvertTo-UnixTimestamp.ps1"
. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Suspend-ServiceDeskRequest {
    [CmdletBinding(DefaultParameterSetName = 'ResumeScheduled')]
    param (
        # Id of the request to suspend
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        # Date and time to resume the request
        [Parameter(ParameterSetName = 'ResumeScheduled')]
        [datetime]
        $Until = (Get-Date).AddDays(3),

        # Request status to set when the request is suspended
        $SuspendStatus = 'Onhold',

        # Status to set when the request is resumed
        [Parameter(ParameterSetName = 'ResumeScheduled')]
        $ResumeStatus = 'Open',

        # Message describing why the request is suspended
        [Parameter(Mandatory, ParameterSetName = 'ResumeScheduled')]
        $Message
    )

    begin {
        $Data = @{
            request = @{
                status = @{
                    name = $SuspendStatus
                }
            }
        }

        if ($Until) {
            $Data.request.onhold_scheduler = @{
                change_to_status = @{
                    name = $ResumeStatus
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
