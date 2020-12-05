function Resolve-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory)]
        $Id,

        [ValidateNotNull()]
        $Message = "Work complete, resolving ticket. Respond to reopen ticket."
    )

    $Headers = @{
        Authorization = "Zoho-oauthtoken $AccessToken"
        Accept = "application/vnd.manageengine.sdp.v3+json"
        "Content-Type" = "application/x-www-form-urlencoded"
    }

    $Data = @{
        request = @{
            resolution = @{
                content = $Message
            }

            status = @{
                name = "Resolved"
            }
        }
    }

    $Body = @{
        input_data = ($Data | ConvertTo-Json -Depth 4 -Compress)
    }

    $RestMethodParameters = @{
        Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$Id"
        Headers = $Headers
        Method = "Put"
        Body = $Body
    }

    $Response = (Invoke-RestMethod @RestMethodParameters).request

    $Request = [ordered] @{
        CompletedTime = $Response.completed_time.display_value
        DisplayId = $Response.display_id
        DueTime = $Response.due_by_time.display_value
        Id = $Response.id
        Requester = $Response.requester.email_id
        Resolution = $Response.resolution
        ResolvedTime = $Response.resolved_time.display_value
        Status = $Response.status.name
        Subject = $Response.subject
        Technician = $Response.technician.email_id
    }

    [pscustomobject] $Request
}