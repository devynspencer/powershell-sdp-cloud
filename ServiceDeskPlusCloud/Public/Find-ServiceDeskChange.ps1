. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Find-ServiceDeskChange {
    param (
        # Change owner to filter results by.
        [string[]]
        $Owner,

        # Change stage to filter results by.
        [string[]]
        $Stage,

        # Maximum number of requests to return. Value passed to the row_count property of the
        # list_info object passed to the API
        $Limit = 100,

        $Page = 1
    )

    # Build the API parameters
    $ApiParams = @{
        Resource = 'changes'
        Limit = $Limit
        Page = $Page
        Operation = 'List'
        SearchCriteria = @()
    }

    # Add search criteria to the API parameters
    if ($PSBoundParameters.ContainsKey('Owner')) {
        $OwnerCriteria = @{
            field = 'change_owner.email_id'
            condition = 'is'
            values = @($Owner)
        }

        # Format additional search criteria after the first to be ANDed together
        if ($ApiParams.SearchCriteria.Count -gt 0) {
            $OwnerCriteria.logical_operator = 'and'
        }

        $ApiParams.SearchCriteria += $OwnerCriteria
    }

    if ($PSBoundParameters.ContainsKey('Stage')) {
        $StageCriteria = @{
            field = 'stage.name'
            condition = 'is'
            values = @($Stage)
        }

        # Format additional search criteria after the first to be ANDed together
        if ($ApiParams.SearchCriteria.Count -gt 0) {
            $StageCriteria.logical_operator = 'and'
        }

        $ApiParams.SearchCriteria += $StageCriteria
    }

    # Remove unused search criteria to avoid API errors
    if ($ApiParams.SearchCriteria.Count -eq 0) {
        $ApiParams.Remove('SearchCriteria')
    }

    # Invoke the API and return the response
    $Response = Invoke-ServiceDeskApi @ApiParams

    $Response
}
