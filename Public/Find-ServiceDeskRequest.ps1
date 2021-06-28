function Find-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [ValidateNotNull()]
        [string[]] $Status = "Open",

        [ValidateNotNull()]
        $Technician
    )

    $Headers = @{
        Authorization = "Zoho-Oauthtoken $AccessToken"
        Accept = "application/vnd.manageengine.sdp.v3+json"
    }

    $Data = @{
        list_info = @{
            row_count = 100
            start_index = 1
            get_total_count = $true

            search_criteria = @(
                @{
                    field = "status.name"
                    condition = "is"
                    values = $Status
                }
            )
        }
    }

    if ($Technician) {
        $Data.list_info.search_criteria += @{
            field = "technician.email_id"
            condition = "is"
            logical_operator = "and"
            values = ,$Technician
        }
    }

    $Body = @{
        input_data = ($Data | ConvertTo-Json -Depth 4 -Compress)
    }

    $RestMethodParameters = @{
        Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests"
        Headers = $Headers
        Method = "Get"
        Body = $Body
    }

    $Response = Invoke-RestMethod @RestMethodParameters

    foreach ($Request in $Response.requests) {
        [pscustomobject] [ordered] @{
            Requester = $Request.requester.email_id
            Template = $Request.template.name
            CreatedTime = $Request.created_time.display_value
            HasDraft = $Request.has_draft
            CancelledComments = $Request.cancel_flag_comments
            DisplayId = $Request.display_id
            Subject = $Request.subject
            Technician = $Request.technician.email_id
            DueTime = $Request.due_by_time.display_value
            IsServiceRequest = $Request.is_service_request
            Cancelled = $Request.cancellation_requested
            HasNotes = $Request.has_notes
            Id = $Request.id
            Maintenance = $Request.maintenance
            Status = $Request.status.name
            Group = $Request.group.name
        }
    }
}