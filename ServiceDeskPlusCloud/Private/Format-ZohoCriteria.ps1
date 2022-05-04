<#
.SYNOPSIS
    Build a hashtable of search criteria matching the specification described in the ServiceDesk Plus API documentation.

.DESCRIPTION
    While the ServiceDesk Plus search criteria supports both flat and nested
    queries, the current implementation in this module will support only
    flat queries initially.

.NOTES
    https://www.manageengine.com/products/service-desk/sdpod-v3-api/getting-started/search-criteria.html

.EXAMPLE
    $Criteria = @()
    $Criteria += Format-ZohoCriteria -Field 'subject' -Condition 'starts with' -Values 'gpo', 'group policy', 'gp
    $Criteria += Format-ZohoCriteria -Field 'technician' -Condition 'is' -Values @{ email_id = 'greg.goodguy@example.com' } -Operator 'AND'
    $Criteria | ConvertTo-Json -Depth 3

    Build a set of criteria for Group Policy requests that greg.goodguy@example.com is assigned.
#>
function Format-ZohoCriteria {
    param (
        # Resource field to target with the criteria
        [Parameter(Mandatory)]
        [string]
        $Field,

        # Criteria values as either an array of hashtable or strings
        # Hashtables are used for values of nested objects, and should match
        # the following format: { "field": "value" }, { "field": "value" }
        [object[]]
        $Values = @(),

        # Condition type to use for criteria comparison
        [ValidateSet(
            'is',
            'is not',
            'greater than',
            'starts with',
            'lesser than'
        )]
        $Condition,

        # Logical operator to append criteria to existing search with
        [ValidateSet(
            'AND',
            'OR'
        )]
        $Operator
    )

    # Build criteria object
    $Criteria = @{
        field = $Field
        condition = $Condition
        values = $Values
    }

    if ($PSBoundParameters.ContainsKey('Operator')) {
        $Criteria.logical_operator = $Operator
    }

    $Criteria
}
