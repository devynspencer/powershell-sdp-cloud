
. "$PSScriptRoot\Format-ZohoCriteria.ps1"
. "$PSScriptRoot\Resolve-UserField"

function Format-ZohoSearch {
    param (
        $Status,

        [string]
        $Technician,

        [Alias('CreatedBy')]
        [string]
        $Creator,

        [string]
        $Requester
    )

    $Criteria = @()

    if ($PSBoundParameters.ContainsKey('Status')) {
        $Criteria += Format-ZohoCriteria -Field 'status.name' -Condition 'is' -Values $Status
    }

    # Handle "user" field inputs, resolve names and email addresses to appropriate field
    $UserParams = @{
        Condition = 'is'
    }

    if ($PSBoundParameters.ContainsKey('Technician')) {
        $TechParams = @{
            Values = $Technician
            Field = Resolve-UserField $Technician -Field 'technician'
        }

        $Criteria += Format-ZohoCriteria @TechParams
    }

    if ($PSBoundParameters.ContainsKey('Creator')) {
        $CreatorParams = @{
            Values = $Creator
            Field = Resolve-UserField $Creator -Field 'creator'
        }

        $Criteria += Format-ZohoCriteria @CreatorParams
    }

    if ($PSBoundParameters.ContainsKey('Requester')) {
        $RequesterParams = @{
            Values = $Requester
            Field = Resolve-UserField $Requester -Field 'requester'
        }

        $Criteria += Format-ZohoCriteria @RequesterParams
    }

    $SearchObj = @{
        search_criteria = $Criteria
    }

    $SearchObj
}
