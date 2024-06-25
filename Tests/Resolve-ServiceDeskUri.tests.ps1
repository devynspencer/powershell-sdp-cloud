BeforeAll {
    Remove-Module ServiceDeskPlusCloud -Force
    Import-Module "$PSScriptRoot\..\ServiceDeskPlusCloud\ServiceDeskPlusCloud.psd1" -Force

    . "$PSScriptRoot\..\ServiceDeskPlusCloud\Private\Resolve-ServiceDeskUri.ps1"
}

Describe 'Resolve-ServiceDeskUri' {

    Context 'when the URI has 1 component' {

        It 'Should return a resource with no id' {
            $Uri = [System.Uri] 'https://sdp.example.com/api/v3/changes'

            $Result = Resolve-ServiceDeskUri -Uri $Uri
            $Result.Resource | Should -Be 'changes'
            $Result.Id | Should -BeNullOrEmpty
        }
    }

    Context 'when the URI has 2 components' {

        It 'Should return a resource with an id' {
            $Uri = [System.Uri] 'https://sdp.example.com/api/v3/changes/123456'

            $Result = Resolve-ServiceDeskUri -Uri $Uri
            $Result.Resource | Should -Be 'changes'
            $Result.Id | Should -Be '123456'
        }
    }

    Context 'when the URI has 3 components' {

        It 'Should return a resource with an id and a child resource with no id' {
            $Uri = [System.Uri] 'https://sdp.example.com/api/v3/changes/123456/tasks'

            $Result = Resolve-ServiceDeskUri -Uri $Uri
            $Result.Resource | Should -Be 'changes'
            $Result.Id | Should -Be '123456'
            $Result.ChildResource | Should -Be 'tasks'
            $Result.ChildId | Should -BeNullOrEmpty
        }
    }

    Context 'when the URI has 4 components' {

        It 'Should return a resource with an id and a child resource with an id' {
            $Uri = [System.Uri] 'https://sdp.example.com/api/v3/changes/123456/tasks/654321'

            $Result = Resolve-ServiceDeskUri -Uri $Uri
            $Result.Resource | Should -Be 'changes'
            $Result.Id | Should -Be '123456'
            $Result.ChildResource | Should -Be 'tasks'
            $Result.ChildId | Should -Be '654321'
        }
    }

    Context 'when the URI is invalid' {

        It 'Should throw an error' {
            $Uri = [System.Uri] 'https://sdp.example.com/api/v3/invalid'

            { Resolve-ServiceDeskUri -Uri $Uri } | Should -Throw "Invalid URI: $Uri"
        }
    }
}
