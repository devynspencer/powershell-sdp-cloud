. "$PSScriptRoot\Invoke-ServiceDeskApi.ps1"

<#
.SYNOPSIS
    Create a new ServiceDesk Plus request.

.PARAMETER Subject
    The subject of the request.

.PARAMETER Description
    The description of the request.

.PARAMETER Requester
    The requester email of the request.

.PARAMETER Group
    The group name of the request.

.PARAMETER Technician
    The technician of the request.

.PARAMETER Category
    The category name of the request.

.PARAMETER SubCategory
    The subcategory name of the request.

.PARAMETER SubCategoryItem
    The subcategory item name of the request.

.PARAMETER Site
    The site name of the request.

.PARAMETER Priority
    The priority of the request.

.PARAMETER Impact
    The impact of the request.

.EXAMPLE
    New-ServiceDeskRequest -Subject "Perform action x on y server"
    Create a new request with a specific subject.
#>

function New-ServiceDeskRequest {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        $Subject,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        $Description,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        $Requester,

        $Group,

        $Technician,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        $Category,

        [ValidateNotNull()]
        $SubCategory,

        [ValidateNotNull()]
        $SubCategoryItem,

        $Site,

        $Priority,

        $Impact
    )

    $Data = @{
        request = @{
            subject = $Subject
            description = $Description

            requester = @{
                email_id = $Requester
            }

            category = @{
                name = $Category
            }
        }
    }

    if ($Subject) {
        $Data.request.subject = $Subject
    }

    if ($Description) {
        $Data.request.description = $Description
    }

    if ($Group) {
        $Data.request.group = @{}
        $Data.request.group.name = $Group
    }

    if ($Technician) {
        $Data.request.technician = @{}
        $Data.request.technician.email_id = $Technician
    }

    if ($SubCategory) {
        $Data.request.subcategory = @{}
        $Data.request.subcategory.name = $SubCategory
    }

    if ($SubCategoryItem) {
        $Data.request.item = @{}
        $Data.request.item.name = $SubCategoryItem
    }

    if ($Site) {
        $Data.request.site = @{}
        $Data.request.site.name = $Site
    }

    if ($Priority) {
        $Data.request.priority = @{}
        $Data.request.priority.name = $Priority
    }

    if ($Impact) {
        $Data.request.impact = @{}
        $Data.request.impact.name = $Impact
    }

    # Build the API parameters
    $ApiParams = @{
        Method = 'Post'
        Operation = 'New'
        Resource = 'requests'
        Data = $Data
    }

    # Invoke the API and return the response
    $Response = Invoke-ServiceDeskApi @ApiParams

    $Response
}
