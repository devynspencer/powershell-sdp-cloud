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

    Set-ServiceDeskRequest -AccessToken $AccessToken -Portal $Portal -Id $Id -Resolution $Message -Status Resolved
}