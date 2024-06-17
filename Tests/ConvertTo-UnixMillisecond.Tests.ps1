BeforeAll {
    . "$PSScriptRoot\..\ServiceDeskPlusCloud\Private\ConvertTo-UnixMillisecond.ps1"
}

Describe 'ConvertTo-UnixMillisecond' {

    It 'Converts a specific date to Unix milliseconds' {
        $InputDate = Get-Date -Year 2022 -Month 6 -Day 1 -Hour 23 -Minute 8 -Second 36
        $ActualResult = ConvertTo-UnixMillisecond -Date $InputDate
        $ActualResult | Should -Be ([Int64] 1654150116)
    }

    It 'Converts the current date to Unix milliseconds' {

    }

    It 'Converts a future date to Unix milliseconds' {

    }
}
