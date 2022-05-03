function Resolve-ServiceDeskUri {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $Uri
    )

    begin {
        $Matchers = @{
            Request = 'https?:\/\/(?<Site>(?:\w+|\.)+)\/app\/(?<Portal>\w+)\/ui\/requests\/(?<Id>\d+)\/\w+'
            Change = 'https?:\/\/(?<Site>(?:\w+|\.)+)\/app\/(?<Portal>\w+)\/ChangeDetails.cc\?CHANGEID=(?<Id>\d+)'
            Project = 'https?:\/\/(?<Site>(?:\w+|\.)+)\/app\/(?<Portal>\w+)\/ProjectDetailsCheck.do\?.*PROJECTID=(?<Id>\d+)'
            Problem = 'https?:\/\/(?<Site>(?:\w+|\.)+)\/app\/(?<Portal>\w+)\/ui\/problems\/(?<Id>\d+)'
            # TODO: Add solutions (currently the solutions uri omits the id)
        }
    }

    process {
        foreach ($ResourceUri in $Uri) {
            if ($Uri -match $Matchers.Request) {
                $ResourceType = "request"
                $Matched = $true
            }

            if ($Uri -match $Matchers.Change) {
                $ResourceType = "change"
                $Matched = $true
            }

            if ($Uri -match $Matchers.Project) {
                $ResourceType = "project"
                $Matched = $true
            }

            if ($Uri -match $Matchers.Problem) {
                $ResourceType = "problem"
                $Matched = $true
            }

            if ($Matched) {
                $Id = $Matches.Id
                $Site = $Matches.Site
                $Portal = $Matches.Portal

                [pscustomobject] @{
                    Id = $Id
                    ResourceType = $ResourceType
                    Site = $Site
                    Portal = $Portal
                }
            }
        }
    }
}