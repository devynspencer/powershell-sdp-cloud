BeforeAll {
    . "$PSScriptRoot\..\ServiceDeskPlusCloud\Private\ConvertTo-UnixTimestamp.ps1"
}

Describe 'ConvertTo-UnixTimestamp' {

    It 'Converts a specific date to Unix milliseconds' {
        $InputDate = [datetime] '6/20/2024 9:43:31 AM'

        ConvertTo-UnixTimestamp -Date $InputDate | Should -Be ([int64] 1718901811000)
    }

    It 'Converts a future date to Unix milliseconds' {
        $InputDate = [datetime] '7/1/2040 8:00:00 AM'

        ConvertTo-UnixTimestamp -Date $InputDate | Should -Be 2224767600000
    }
}
