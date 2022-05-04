
. "$PSScriptRoot\Format-ZohoCriteria.ps1"
. "$PSScriptRoot\Resolve-UserField"

function Format-ZohoSearch {
    param (
        $Status
    )

    $Criteria = @()

    if ($PSBoundParameters.ContainsKey('Status')) {
        $Criteria += Format-ZohoCriteria -Field 'status.name' -Condition 'is' -Values $Status
    }

    $SearchObj = @{
        search_criteria = $Criteria
    }

    $SearchObj
}
