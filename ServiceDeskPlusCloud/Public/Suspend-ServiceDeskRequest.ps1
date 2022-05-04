. "$PSScriptRoot\..\Private\ConvertTo-UnixMillisecond.ps1"
. "$PSScriptRoot\..\private\Format-ZohoHeader.ps1"

function Suspend-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $Portal,

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
                    value = ConvertTo-UnixMillisecond $Until
                }
            }

            if ($Message) {
                $Data.request.onhold_scheduler.comments = $Message
            }
        }

        $Body = @{
            input_data = ($Data | ConvertTo-Json -Depth 5 -Compress)
        }
    }

    process {
        foreach ($RequestId in $Id) {
            $RestMethodParameters = @{
                Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$RequestId"
                Headers = Format-ZohoHeader
                Method = 'Put'
                Body = $Body
            }

            $Response = (Invoke-RestMethod @RestMethodParameters).request
        }
    }
}
