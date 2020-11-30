function Get-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Id,

        [Parameter(Mandatory)]
        $Portal
    )

    $Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$Id"

    $Headers = @{
        Authorization = "Zoho-oauthtoken $AccessToken"
        Accept = "application/v3+json"
    }

    $Response = (Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers).request

    [pscustomobject] $Request = @{
        ApprovalStatus = $Response.approval_status
        Assets = $Response.assets
        AssignedTime = $Response.assigned_time
        Attachments = $Response.attachments
        Cancelled = $Response.cancellation_requested
        CancelledComments = $Response.cancel_flag_comments
        Category = $Response.category
        CompletedTime = $Response.completed_time
        Creator = $Response.created_by
        CreatedTime = $Response.created_time
        DeletedTime = $Response.deleted_time
        Department = $Response.department
        Description = $Response.description
        DisplayId = $Response.display_id
        DueTime = $Response.due_by_time
        EmailBcc = $Response.email_bcc
        EmailCc = $Response.email_cc
        EmailNotifies = $Response.email_ids_to_notify
        EmailTo = $Response.email_to
        FirstResponseDueTime = $Response.first_response_due_by_time
        Group = $Response.group
        HasAttachments = $Response.has_attachments
        HasChangeInitiatedRequest = $Response.has_change_initiated_request
        HasDraft = $Response.has_draft
        HasLinked = $Response.has_linked_requests
        HasNotes = $Response.has_notes
        HasProblem = $Response.has_problem
        HasProject = $Response.has_project
        HasRequestInitiatedChange = $Response.has_request_initiated_change
        Id = $Response.id
        IsEscalated = $Response.is_escalated
        IsFcr = $Response.is_fcr
        IsFirstResponseOverdue = $Response.is_first_response_overdue
        IsOverdue = $Response.is_overdue
        IsRead = $Response.is_read
        IsReopened = $Response.is_reopened
        IsServiceRequest = $Response.is_service_request
        IsTrashed = $Response.is_trashed
        Item = $Response.item
        LastUpdatedTime = $Response.last_updated_time
        Lifecycle = $Response.lifecycle
        LinkedToRequest = $Response.linked_to_request
        Maintenance = $Response.maintenance
        NotificationStatus = $Response.notification_status
        OnholdScheduler = $Response.onhold_scheduler
        ProjectId = $Response.project_id
        Requester = $Response.requester
        TemplateTaskIds = $Response.request_template_task_ids
        Resolution = $Response.resolution
        ResolvedTime = $Response.resolved_time
        RespondedTime = $Response.responded_time
        ServiceCategory = $Response.service_category
        Site = $Response.site
        Sla = $Response.sla
        Status = $Response.status
        SubCategory = $Response.subcategory
        Subject = $Response.subject
        Technician = $Response.technician
        Template = $Response.template
        TimeElapsed = $Response.time_elapsed
        UdfFields = $Response.udf_fields
        UnrepliedCount = $Response.unreplied_count
    }

    $Request
}