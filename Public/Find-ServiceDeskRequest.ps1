function Find-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal
    )

    $Headers = @{
        Authorization = "Zoho-oauthtoken $AccessToken"
        Accept = "application/vnd.manageengine.sdp.v3+json"
    }

    $Data = @{
        list_info = @{
            row_count = 100
            start_index = 1
            get_total_count = $true
        }
    }

    $Body = @{
        input_data = ($Data | ConvertTo-Json -Depth 3)
        format = "json"
    }

    $Response = Invoke-RestMethod -Uri "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests" -Method Get -Headers $Headers -Body $Body

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