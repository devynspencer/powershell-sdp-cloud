function Add-ServiceDeskNote {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        $Id,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        $Message,

        [switch]
        $NotifyTechnician,

        [switch]
        $Public
    )

    $Headers = @{
        Authorization = "Zoho-oauthtoken $AccessToken"
        Accept = "application/vnd.manageengine.sdp.v3+json"
    }

    $Data = @{
        request_note = @{
            description = $Message
            notify_technician = $false
            show_to_requester = $false
        }
    }

    # Coddle switch parameters until they function as designed
    if ($NotifyTechnician) {
        $Data.request_note.notify_technician = $true
    }

    if ($Public) {
        $Data.request_note.show_to_requester = $true
    }

    $Body = @{
        input_data = ($Data | ConvertTo-Json -Depth 4 -Compress)
    }

    $RestMethodParameters = @{
        Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$Id/notes"
        Headers = $Headers
        Method = "Post"
        Body = $Body
    }

    Invoke-RestMethod @RestMethodParameters
}