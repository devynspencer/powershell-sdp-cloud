. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

function Set-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        $Portal,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]
        $Id,

        [ValidateNotNull()]
        $Subject,

        [ValidateNotNull()]
        $Description,

        [ValidateNotNull()]
        $Status,

        [ValidateNotNull()]
        $Requester,

        $Group,

        $Technician,

        [ValidateNotNull()]
        $Category,

        [ValidateNotNull()]
        $SubCategory,

        [ValidateNotNull()]
        $SubCategoryItem,

        $Site,

        $Priority,

        $Impact,

        $Resolution
    )

    begin {
        $Data = @{
            request = @{}
        }

        if ($Subject) {
            $Data.request.subject = $Subject
        }

        if ($Description) {
            $Data.request.description = $Description
        }

        if ($Status) {
            $Data.request.status = @{ name = $Status }
        }

        if ($Requester) {
            $Data.request.requester = @{ email_id = $Requester }
        }

        if ($Group) {
            $Data.request.group = @{ name = $Group }
        }

        if ($Technician) {
            $Data.request.technician = @{ email_id = $Technician }
        }

        if ($Category) {
            $Data.request.category = @{ name = $Category }
        }

        if ($SubCategory) {
            $Data.request.subcategory = @{ name = $SubCategory }
        }

        if ($SubCategoryItem) {
            $Data.request.item = @{ name = $SubCategoryItem }
        }

        if ($Site) {
            $Data.request.site = @{ name = $Site }
        }

        if ($Priority) {
            $Data.request.priority = @{ name = $Priority }
        }

        if ($Impact) {
            $Data.request.impact = @{ name = $Impact }
        }

        if ($Resolution) {
            $Data.request.resolution = @{ content = $Resolution }
        }
    }

    process {
        foreach ($RequestId in $Id) {
            # Build the API parameters
            $InvokeParams = @{
                Method = 'Put'
                Operation = 'Update'
                Resource = 'requests'
                Id = $RequestId
                Data = $Data
            }

            # Make the API call
            $Response = Invoke-ServiceDeskApi @InvokeParams

            $Response
        }
    }
}
