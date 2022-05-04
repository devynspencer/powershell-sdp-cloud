
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

    $Shared = @{
        Condition = 'is'
    }

    if ($PSBoundParameters.ContainsKey('Status')) {
        $Criteria += Format-ZohoCriteria @Shared -Field 'status.name' -Values $Status
    }

    # Handle "user" field inputs, resolve names and email addresses to appropriate field
    if ($PSBoundParameters.ContainsKey('Technician')) {
        $TechParams = @{
            Values = $Technician
            Field = Resolve-UserField $Technician -Field 'technician'
        }

        $Criteria += Format-ZohoCriteria @Shared @TechParams
    }

    if ($PSBoundParameters.ContainsKey('Creator')) {
        $CreatorParams = @{
            Values = $Creator
            Field = Resolve-UserField $Creator -Field 'creator'
        }

        $Criteria += Format-ZohoCriteria @Shared @CreatorParams
    }

    if ($PSBoundParameters.ContainsKey('Requester')) {
        $RequesterParams = @{
            Values = $Requester
            Field = Resolve-UserField $Requester -Field 'requester'
        }

        $Criteria += Format-ZohoCriteria @Shared @RequesterParams
        $Criteria += Format-ZohoCriteria @RequesterParams
    }

    # Build output object
    $SearchObj = @{
        search_criteria = $Criteria
    }

    $SearchObj
}
