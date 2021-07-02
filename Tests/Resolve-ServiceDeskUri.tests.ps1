BeforeAll {
    $ModuleRoot = (Get-Item $PSScriptRoot).Parent.FullName
    $SubjectFileName = Split-Path -Path $PSCommandPath.Replace('.tests.ps1', '.ps1') -Leaf
    . "$ModuleRoot\Public\$SubjectFileName"
}

Describe 'Resolve-ServiceDeskUri' {
    Context 'for any uri' {
        It 'skips uris without an id' {
            $Uri = 'https://sdp.example.com/app/is/ui/requests'
            Resolve-ServiceDeskUri -Uri $Uri | Should -Be $null
        }

        It 'skips unrelated uris' {
            $Uri = 'https://google.com'
            Resolve-ServiceDeskUri -Uri $Uri | Should -Be $null
        }

        It 'returns results from pipeline input' {
            $Uri = 'https://sdp.example.com/app/is/ui/requests/118870000007832062/details'
            $Uri | Resolve-ServiceDeskUri | Should -Not -Be $null
        }
    }

    Context 'for multiple uris' {
        It 'returns results for each uri' {
            $Uris = @(
                'https://sdp.example.com/app/is/ui/requests/118870000007832126/details'
                'https://sdp.example.com/app/is/ui/requests/118870000007812729/details'
                'https://sdp.example.com/app/is/ui/requests/118870000007832062/details'
            )
            $Results = Resolve-ServiceDeskUri -Uri $Uris
            $Results.Count | Should -Be 3
        }

        It 'returns results from pipeline input' {
            $Uris = @(
                'https://sdp.example.com/app/is/ui/requests/118870000007832126/details'
                'https://sdp.example.com/app/is/ui/requests/118870000007812729/details'
                'https://sdp.example.com/app/is/ui/requests/118870000007832062/details'
            )
            ($Uris | Resolve-ServiceDeskUri).Count | Should -Be 3
        }
    }

    Context 'given a request uri' {
        It 'returns the correct resource id' {
            $Uri = 'https://sdp.example.com/app/is/ui/requests/118870000007832126/details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id | Should -Be '118870000007832126'
        }

        It 'returns a resource id with a valid length' {
            $Uri = 'https://sdp.example.com/app/is/ui/requests/118870000007832126/details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id.Length | Should -Be 18
        }

        It 'returns the correct resource type' {
            $Uri = 'https://sdp.example.com/app/is/ui/requests/118870000007832126/details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.ResourceType | Should -Be 'request'
        }

        It 'returns the correct site' {
            $Uri = 'https://sdp.example.com/app/is/ui/requests/118870000007832126/details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Site | Should -Be 'sdp.example.com'
        }

        It 'returns the correct portal' {
            $Uri = 'https://sdp.example.com/app/is/ui/requests/118870000007832126/details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Portal | Should -Be 'is'
        }
    }

    Context 'given a change uri' {
        It 'returns the correct resource id' {
            $Uri = 'https://sdp.example.com/app/is/ChangeDetails.cc?CHANGEID=118870000005973815&selectTab=submission&subTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id | Should -Be '118870000005973815'
        }

        It 'returns a resource id with a valid length' {
            $Uri = 'https://sdp.example.com/app/is/ChangeDetails.cc?CHANGEID=118870000005973815&selectTab=submission&subTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id.Length | Should -Be 18
        }

        It 'returns the correct resource type' {
            $Uri = 'https://sdp.example.com/app/is/ChangeDetails.cc?CHANGEID=118870000005973815&selectTab=submission&subTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.ResourceType | Should -Be 'change'
        }

        It 'returns the correct site' {
            $Uri = 'https://sdp.example.com/app/is/ChangeDetails.cc?CHANGEID=118870000005973815&selectTab=submission&subTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Site | Should -Be 'sdp.example.com'
        }

        It 'returns the correct portal' {
            $Uri = 'https://sdp.example.com/app/is/ChangeDetails.cc?CHANGEID=118870000005973815&selectTab=submission&subTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Portal | Should -Be 'is'
        }
    }

    Context 'given a project uri' {
        It 'returns the correct resource id' {
            $Uri = 'https://sdp.example.com/app/is/ProjectDetailsCheck.do?fromListView=true&PROJECTID=118870000006706085'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id | Should -Be '118870000006706085'
        }

        It 'returns a resource id with a valid length' {
            $Uri = 'https://sdp.example.com/app/is/ProjectDetailsCheck.do?fromListView=true&PROJECTID=118870000006706085'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id.Length | Should -Be 18
        }

        It 'returns the correct resource type' {
            $Uri = 'https://sdp.example.com/app/is/ProjectDetailsCheck.do?fromListView=true&PROJECTID=118870000006706085'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.ResourceType | Should -Be 'project'
        }

        It 'returns the correct site' {
            $Uri = 'https://sdp.example.com/app/is/ProjectDetailsCheck.do?fromListView=true&PROJECTID=118870000006706085'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Site | Should -Be 'sdp.example.com'
        }

        It 'returns the correct portal' {
            $Uri = 'https://sdp.example.com/app/is/ProjectDetailsCheck.do?fromListView=true&PROJECTID=118870000006706085'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Portal | Should -Be 'is'
        }
    }

    Context 'given a problem uri' {
        It 'returns the correct resource id' {
            $Uri = 'https://sdp.example.com/app/is/ui/problems/118870000007936288/details?selectTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id | Should -Be '118870000007936288'
        }

        It 'returns a resource id with a valid length' {
            $Uri = 'https://sdp.example.com/app/is/ui/problems/118870000007936288/details?selectTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Id.Length | Should -Be 18
        }

        It 'returns the correct resource type' {
            $Uri = 'https://sdp.example.com/app/is/ui/problems/118870000007936288/details?selectTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.ResourceType | Should -Be 'problem'
        }

        It 'returns the correct site' {
            $Uri = 'https://sdp.example.com/app/is/ui/problems/118870000007936288/details?selectTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Site | Should -Be 'sdp.example.com'
        }

        It 'returns the correct portal' {
            $Uri = 'https://sdp.example.com/app/is/ui/problems/118870000007936288/details?selectTab=details'
            $Results = Resolve-ServiceDeskUri -Uri $Uri
            $Results.Portal | Should -Be 'is'
        }
    }
}