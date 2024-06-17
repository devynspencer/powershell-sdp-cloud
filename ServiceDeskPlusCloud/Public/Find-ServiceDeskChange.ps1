. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Find-ServiceDeskChange {
    param (
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

    # Remove unused search criteria to avoid API errors
    if ($ApiParams.SearchCriteria.Count -eq 0) {
        $ApiParams.Remove('SearchCriteria')
    }

    # Invoke the API and return the response
    $Response = Invoke-ServiceDeskApi @ApiParams

    $Response
}
