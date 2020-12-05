. "$PSScriptRoot\Set-ServiceDeskRequest"

function Resolve-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory)]
        $Id,

        [ValidateNotNull()]
        $Message = "Work complete, resolving ticket. Respond to reopen ticket."
    )

    $PSBoundParameters.Remove("Message") | Out-Null

    Set-ServiceDeskRequest @PSBoundParameters -Resolution $Message -Status Resolved
}