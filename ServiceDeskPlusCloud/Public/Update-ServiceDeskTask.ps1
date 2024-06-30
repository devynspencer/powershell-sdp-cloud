. "$PSScriptRoot\..\Private\ConvertTo-UnixTimestamp.ps1"
. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Update-ServiceDeskTask {
    param (
        # The unique identifier of the task
        [Parameter(Mandatory)]
        $Id,

        # Title of task
        [Parameter(Mandatory)]
        $Title,

        # Description of task
        $Description = '',

        # The user assigned to task
        [Parameter(Mandatory)]
        [Alias('Technician')]
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
        [Alias('Hours')]
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

        $TaskType
    )

    # Build request data
    $Data = @{
        task = @{}
    }

    # Add required parameters to request data
    if ($PSBoundParameters.ContainsKey('Title')) {
        $Data.task.title = $Title
    }

    if ($PSBoundParameters.ContainsKey('Description')) {
        $Data.task.description = $Description
    }

    if ($PSBoundParameters.ContainsKey('Owner')) {
        $Data.task.owner = @{ email_id = $Owner }
    }

    # Add scheduling parameters to request data
    if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
        $UnixScheduledStartTime = ConvertTo-UnixTimestamp -DateTime $ScheduledStartTime
        $Data.task.scheduled_start_time = $UnixScheduledStartTime
    }

    if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
        $UnixScheduledEndTime = ConvertTo-UnixTimestamp -DateTime $ScheduledEndTime
        $Data.task.scheduled_end_time = $UnixScheduledEndTime
    }

    # Add optional parameters to request data
    if ($PSBoundParameters.ContainsKey('StartTime')) {
        $UnixStartTime = ConvertTo-UnixTimestamp -DateTime $StartTime
        $Data.task.start_time = $UnixStartTime
    }

    if ($PSBoundParameters.ContainsKey('EndTime')) {
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
        Method = 'Put'
        Operation = 'Update'
        Resource = 'tasks'
        Id = $Id
        Data = $Data
    }

    # Invoke the API and return the response
    $Response = Invoke-ServiceDeskApi @InvokeParams

    $Response
}
