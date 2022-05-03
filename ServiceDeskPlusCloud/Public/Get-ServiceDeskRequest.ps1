function Get-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        [Parameter(Mandatory)]
        $Portal
    )

    begin {
        $Headers = @{
            Authorization = "Zoho-Oauthtoken $AccessToken"
            Accept = "application/vnd.manageengine.sdp.v3+json"
        }
    }

    process {
        foreach ($RequestId in $Id) {
            $RestMethodParameters = @{
                Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$RequestId"
                Headers = $Headers
                Method = "Get"
            }

            $Response = (Invoke-RestMethod @RestMethodParameters).request

            $Request = [ordered] @{
                ApprovalStatus = $Response.approval_status
                Assets = $Response.assets
                AssignedTime = $Response.assigned_time.display_value
                Attachments = $Response.attachments
                Cancelled = $Response.cancellation_requested
                CancelledComments = $Response.cancel_flag_comments
                Category = $Response.category.name
                CompletedTime = $Response.completed_time.display_value
                Creator = $Response.created_by.email_id
                CreatedTime = $Response.created_time.display_value
                DeletedTime = $Response.deleted_time.display_value
                Department = $Response.department.name
                Description = $Response.description
                DisplayId = $Response.display_id
                DueTime = $Response.due_by_time.display_value
                EmailBcc = $Response.email_bcc
                EmailCc = $Response.email_cc
                EmailNotifies = $Response.email_ids_to_notify
                EmailTo = $Response.email_to
                FirstResponseDueTime = $Response.first_response_due_by_time.display_value
                Group = $Response.group.name
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
                LastUpdatedTime = $Response.last_updated_time.display_value
                Lifecycle = $Response.lifecycle
                LinkedToRequest = $Response.linked_to_request
                Maintenance = $Response.maintenance
                NotificationStatus = $Response.notification_status
                OnholdScheduler = $Response.onhold_scheduler
                ProjectId = $Response.project_id
                Requester = $Response.requester.email_id
                TemplateTaskIds = $Response.request_template_task_ids
                Resolution = $Response.resolution
                ResolvedTime = $Response.resolved_time.display_value
                RespondedTime = $Response.responded_time.display_value
                ServiceCategory = $Response.service_category
                Site = $Response.site
                Sla = $Response.sla.name
                Status = $Response.status.name
                SubCategory = $Response.subcategory.name
                Subject = $Response.subject
                Technician = $Response.technician.email_id
                Template = $Response.template.name
                TimeElapsed = $Response.time_elapsed
                UdfFields = $Response.udf_fields
                UnrepliedCount = $Response.unreplied_count
            }

            [pscustomobject] $Request
        }
    }
}