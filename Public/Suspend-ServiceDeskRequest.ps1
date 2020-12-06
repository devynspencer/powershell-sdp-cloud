. "$PSScriptRoot\..\Private\ConvertTo-UnixMillisecond.ps1"

function Suspend-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Id,

        $Until,

        $Message
    )

    $Headers = @{
        Authorization = "Zoho-oauthtoken $AccessToken"
        Accept = "application/vnd.manageengine.sdp.v3+json"
        "Content-Type" = "application/x-www-form-urlencoded"
    }

    $Data = @{
        request = @{
            status = @{
                name = "Onhold"
            }
        }
    }

    if ($Until) {
        $Data.request.onhold_scheduler = @{
            change_to_status = @{
                name = "Open"
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

    $RestMethodParameters = @{
        Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$Id"
        Headers = $Headers
        Method = "Put"
        Body = $Body
    }

    $Response = (Invoke-RestMethod @RestMethodParameters).request
}