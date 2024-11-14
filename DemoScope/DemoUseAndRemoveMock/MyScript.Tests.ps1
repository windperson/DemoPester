#Requires -Version 7
Describe "MyFunction" {
    BeforeAll {
        Import-Module "$PSScriptRoot/MyScript.psm1" -Verbose -Force
    }
    It "should return the mocked time" {
        InModuleScope MyScript {
            Mock -CommandName Get-CurrentTime -MockWith {
                $output = "2024-11-14 08:00:00"
                Write-Information -MessageData "In Mocked Get-CurrentTime(), output=$output" -InformationAction Continue
                return $output
            }

            $result = MyDateTime
            $result | Should -Be "The current time is 2024-11-14 08:00:00"

            # Remove mocked Get-CurrentTime Function
            Remove-Alias Get-CurrentTime
        }

        # Call the function again and check the result without the mock
        $result = MyDateTime
        $result | Should -Not -Be "The current time is 2024-11-14 08:00:00"
    }
}