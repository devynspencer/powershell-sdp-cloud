function Add-ServiceDeskNote {
    param (
        [Parameter(Mandatory)]
        $AccessToken,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $Message,

        [switch]
        $Notify,

        [bool]
        $Public = $true
    )

    begin {
        $Headers = @{
            Authorization = "Zoho-Oauthtoken $AccessToken"
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
        if ($Notify) {
            $Data.request_note.notify_technician = $true
        }

        if ($Public) {
            $Data.request_note.show_to_requester = $true
        }

        $Body = @{
            input_data = ($Data | ConvertTo-Json -Depth 4 -Compress)
        }
    }

    process {
        foreach ($RequestId in $Id) {
            $RestMethodParameters = @{
                Uri = "https://sdpondemand.manageengine.com/app/$Portal/api/v3/requests/$RequestId/notes"
                Headers = $Headers
                Method = "Post"
                Body = $Body
            }

            Invoke-RestMethod @RestMethodParameters
        }
    }
}