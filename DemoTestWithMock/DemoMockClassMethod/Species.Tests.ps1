BeforeAll {
    . "$PSScriptRoot\Species.ps1"
}

Describe "Human class" {
    It "Test Jump() method" {
        # Arrange
        Mock -CommandName Write-Host -MockWith {
            $hooked = $PesterBoundParameters['Object'][0]
            $hooked | Should -BeLike '* is jumping'
            return
        }

        # Act
        $human = [Human]::new("Pester")
        $human.Jump()

        # Assert
        Assert-MockCalled -CommandName Write-Host -Times 1 -Exactly
    }
    It "Test SayHello() method" {
        # Arrange
        $human = [Human]::new("Pester")
        $expectedGreeting = "Hello, I am Pester"

        # Act
        $actualGreeting = $human.SayHello()

        # Assert
        $actualGreeting | Should -Be $expectedGreeting
    }
    It "Test SayHello(`$Name) method" {
        # Arrange
        $human = [Human]::new("Pester")
        $expectedGreeting = "Hello, PowerShell. I am Pester"

        # Act
        $actualGreeting = $human.SayHello("PowerShell")

        # Assert
        $actualGreeting | Should -Be $expectedGreeting
    }
}

Describe "dog class" {
    It "Mock Speak() method" {
        # Arrange
        $originDog = [dog]::new("Poppy")
        # Note: you cannot use class name
        # (PowerShell will convert it as "System.String" instead of "System.Type")
        # directly for New-MockObject cmdlet's -Type parameter
        $mockedDog = New-MockObject -Type $([dog]) -Methods @{ Speak = { return "Mocked Woof!" } }

        # Act
        $originSpeak = $originDog.Speak()
        $mockedSpeak = $mockedDog.Speak()

        # Assert
        $mockedDog.Name | Should -Not -Be "Poppy"
        $originSpeak | Should -Be "Woof!"
        $mockedSpeak | Should -Be "Mocked Woof!"
    }
}

Describe "kangaroo class" {
    It "Test Jump() method" {
        # Arrange
        $kangaroo = [kangaroo]::new()
        $expectedJump = "look at that kangaroo jump!look at that kangaroo jump!"

        # Act
        $actualJump = $kangaroo.Jump()

        # Assert
        $actualJump | Should -Be $expectedJump
    }
    It "Mock Speak() method" {
        # Arrange
        $originKangaroo = [kangaroo]::new()
        $originKangaroo.Name = "Kenny"
        { $originKangaroo.Speak() } | Should -Throw "Speak method should be overridden in child class" `
            -ExceptionType ([System.NotImplementedException])

        # Note: Using New-MockObject will actually patch the original object with the mocked method(s)
        $mockedKangaroo = New-MockObject -InputObject $originKangaroo -Methods @{ Speak = { return "Mocked Boing!" } }

        # Act
        $originSpeak = $originKangaroo.Speak()
        $mockedSpeak = $mockedKangaroo.Speak()

        # Assert
        $mockedKangaroo.Name | Should -Be "Kenny"
        $originSpeak | Should -Be "Mocked Boing!"
        $mockedSpeak | Should -Be "Mocked Boing!"
    }
}