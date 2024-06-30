. "$PSScriptRoot\..\Private\ConvertTo-UnixTimestamp.ps1"
. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function New-ServiceDeskTask {
    param (
        # Title of task
        [Parameter(Mandatory)]
        $Title,

        # Description of task
        $Description = '',

        # The user assigned to task
        [Parameter(Mandatory)]
        $Owner,

        # Scheduled start time of task
        [datetime]
        $ScheduledStartTime,

        # Scheduled end time of task
        [datetime]
        $ScheduledEndTime,

        # Actual start time of task
        [datetime]
        $StartTime,

        # Actual end time of task
        [datetime]
        $EndTime,

        # Estimated effort in hours
        $EstimatedHours,

        # Task completion progress, measured as a percentage
        $PercentComplete,

        # Additional cost of task
        $AdditionalCost,

        # Group assigned to task
        $Group,

        # Site associated with task
        $Site,

        # Priority of task
        $Priority,

        # Status of task
        $Status,

        # Type of task (maps to task_type)
        $TaskType
    )

    # Build request data
    $Data = @{
        task = @{
            title = $Title
            description = $Description
            owner = @{ email_id = $Owner }
        }
    }

    # Add scheduling parameters to request data
    if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
        # Add scheduled start time to the API parameters
        $UnixScheduledStartTime = ConvertTo-UnixTimestamp -DateTime $ScheduledStartTime
        $Data.task.scheduled_start_time = $UnixScheduledStartTime

        # If scheduled end time not specified, but estimated hours *are*, calculate scheduled end
        # time based on available information
        if (!$PSBoundParameters.ContainsKey('ScheduledEndTime') -and $PSBoundParameters.ContainsKey('EstimatedHours')) {
            $ScheduledEndTime = $ScheduledStartTime.AddHours($EstimatedHours)
        }
    }

    if ($null -ne $ScheduledEndTime) {
        # Set scheduled end time either from parameter or calculated value
        $UnixScheduledEndTime = ConvertTo-UnixTimestamp -DateTime $ScheduledEndTime
        $Data.task.scheduled_end_time = $UnixScheduledEndTime
    }

    # Add optional parameters to request data
    if ($PSBoundParameters.ContainsKey('StartTime')) {
        # Add actual start time to API parameters
        $UnixStartTime = ConvertTo-UnixTimestamp -DateTime $StartTime
        $Data.task.start_time = $UnixStartTime
    }

    if ($PSBoundParameters.ContainsKey('EndTime')) {
        # Add actual end time to API parameters
        $UnixEndTime = ConvertTo-UnixTimestamp -DateTime $EndTime
        $Data.task.end_time = $UnixEndTime
    }

    if ($PSBoundParameters.ContainsKey('Group')) {
        $Data.task.group = @{ name = $Group }
    }

    if ($PSBoundParameters.ContainsKey('Site')) {
        $Data.task.site = @{ name = $Site }
    }

    if ($PSBoundParameters.ContainsKey('Priority')) {
        $Data.task.priority = @{ name = $Priority }
    }

    if ($PSBoundParameters.ContainsKey('Status')) {
        $Data.task.status = $Status
    }

    if ($PSBoundParameters.ContainsKey('PercentComplete')) {
        $Data.task.percentage_completion = $PercentComplete
    }

    if ($PSBoundParameters.ContainsKey('AdditionalCost')) {
        $Data.task.additional_cost = $AdditionalCost
    }

    if ($PSBoundParameters.ContainsKey('EstimatedHours')) {
        $Data.task.estimated_effort_hours = $EstimatedHours
    }

    if ($PSBoundParameters.ContainsKey('TaskType')) {
        $Data.task.task_type = $TaskType
    }

    # Build the API parameters
    $InvokeParams = @{
        Method = 'Post'
        Operation = 'New'
        Resource = 'tasks'
        Data = $Data
    }

    # Invoke the API and return the response
    $Response = Invoke-ServiceDeskApi @InvokeParams

    $Response
}
