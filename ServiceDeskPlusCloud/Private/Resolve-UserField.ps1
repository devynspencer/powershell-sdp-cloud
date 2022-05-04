<#
.SYNOPSIS
    Match an identifier to the appropriate nested field of a user object.

.EXAMPLE
    Resolve-UserField -Identity 'greg.goodguy@example.com' -Field 'requester'
    Determine the field name used by the provided identity string.
#>
function Resolve-UserField {
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Identity,

        [ValidateSet(
            'technician',
            'requester',
            'on_behalf_of',
            'created_by'
        )]
        $Field
    )

    if ($Identity -match '@') {
        $NestedField = 'email_id'
    }

    else {
        $NestedField = 'name'
    }

    "$Field.$NestedField"
}
