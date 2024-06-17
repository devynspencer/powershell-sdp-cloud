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
    }

    # Invoke the API and return the response
    $Response = Invoke-ServiceDeskApi @ApiParams

    $Response
}
