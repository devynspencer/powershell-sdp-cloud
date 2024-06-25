function Resolve-ServiceDeskUri {
    param (
        [Parameter(Mandatory)]
        [System.Uri]
        $Uri
    )

    # Extract the resource(s) from the URI
    $Components = $Uri.Segments.Replace('/', '') | select -Skip 3

    Write-Verbose "[Resolve-ServiceDeskUri] URI has [$($Components.Count)] component(s): [$($Components -join ', ')]"

    # Identify resources based on the number of components
    switch ($Components.Count) {
        # Resource with no id, for example: /changes
        1 {
            $Resource = $Components

            Write-Verbose "[Resolve-ServiceDeskUri] URI is a [$Resource] resource with no id"
        }

        # Resource with id, for example: /changes/123456
        2 {
            $Resource = $Components[0]
            $Id = $Components[1]

            Write-Verbose "[Resolve-ServiceDeskUri] URI is a [$Resource] resource with id [$Id]"
        }

        # Resource with id and child resource with no id, for example: /changes/123456/tasks
        3 {
            $Resource = $Components[0]
            $Id = $Components[1]
            $ChildResource = $Components[2]

            Write-Verbose "[Resolve-ServiceDeskUri] URI is a [$Resource] resource with id [$Id] with a child [$ChildResource] with no id"
        }

        # Resource with id and child resource with id, for example: /changes/123456/tasks/654321
        4 {
            $Resource = $Components[0]
            $Id = $Components[1]
            $ChildResource = $Components[2]
            $ChildId = $Components[3]

            Write-Verbose "[Resolve-ServiceDeskUri] URI is a [$Resource] resource with id [$Id] with a child [$ChildResource] resource with id [$ChildId]"
        }

        default {
            throw "Invalid URI: $Uri"
        }
    }

    # Return the resolved resources
    [pscustomobject] @{
        Resource = $Resource
        Id = $Id
        ChildResource = $ChildResource
        ChildId = $ChildId
    }
}
