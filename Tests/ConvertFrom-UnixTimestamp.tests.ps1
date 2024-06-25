BeforeAll {
    . "$PSScriptRoot\..\ServiceDeskPlusCloud\Private\ConvertFrom-UnixTimestamp.ps1"
}

Describe 'ConvertFrom-UnixTimestamp' {

    It 'Converts a specific date from Unix milliseconds' {
        $InputTimestamp = 1718901811000
        $ExpectedDate = Get-Date '6/20/2024 4:43:31 PM'

        ConvertFrom-UnixTimestamp -Timestamp $InputTimestamp | Should -Be $ExpectedDate
    }
}
