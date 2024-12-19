#Requires -Version 7
#Requires -Module @{ ModuleName='Pester'; ModuleVersion="5.6.1"}

BeforeAll {
    # Load the Greeter class
    . "$PSScriptRoot\Greeter.ps1"
}

Describe "Test Greeter class methods without mocking" {
    It "Should return the correct greeting" {
        # Arrange
        $greeter = [Greeter]::new()
        $expectedGreeting = "Hello, World!"

        # Act
        $actualGreeting = $greeter.SayHello()

        # Assert
        $actualGreeting | Should -Be $expectedGreeting
    }

    It "Should return the correct greeting with a custom name" {
        # Arrange
        $greeter = [Greeter]::new()
        $greeter.Name = "Pester"
        $expectedGreeting = "Hello, Pester!"

        # Act
        $actualGreeting = $greeter.SayHello()

        # Assert
        $actualGreeting | Should -Be $expectedGreeting
    }

    It "Should return the correct greeting with a custom greeting" {
        # Arrange
        $greeter = [Greeter]::new()
        $greeter.Greeting = "Hi"
        $expectedGreeting = "Hi, World!"

        # Act
        $actualGreeting = $greeter.SayHello()

        # Assert
        $actualGreeting | Should -Be $expectedGreeting
    }

    It "Should return the correct greeting with a custom greeting and name" {
        # Arrange
        $greeter = [Greeter]::new()
        $greeter.Greeting = "Hi"
        $greeter.Name = "Pester"
        $expectedGreeting = "Hi, Pester!"

        # Act
        $actualGreeting = $greeter.SayHello()

        # Assert
        $actualGreeting | Should -Be $expectedGreeting
    }

    It "Test SayHelloWithTime() by subclassing Greeter" {
        # Arrange
        <#
        Because the Greeter class is in a script (.ps1) file, not in a module (.psm1) file,
        The InModuleScope of Pester cannot use on it,
        We need to create a dynamic module via New-Module cmdlet to use the Greeter class source code
        #>
        $greeterModule = New-Module -Name Greeter -ScriptBlock {
            . "$PSScriptRoot\Greeter.ps1"
            <#
            Override the GetCurrentTime() method with a mock implementation in a sub-class,
            but due to the limitation of PowerShell language syntax parser,
            the dot-sorced [Greeter] class definition is not known at the time of parsing the script block and causes a syntax error,
            we need to use the [ScriptBlock]::Create() method to define the sub-class body via the string literal
            #>
            . ([ScriptBlock]::Create('
            class MockGreeter : Greeter {
                [string] GetCurrentTime() {
                    return "MockedTime"
                }
            }
            '));
        } | Import-Module -PassThru

        # Act
        $greeter = & $greeterModule.NewBoundScriptBlock({ [MockGreeter]::new() })
        # Or use the short hand syntax: https://stackoverflow.com/a/40441684/1075882
        # $greeter = & $greeterModule {[MockGreeter]::new()}
        $actualGreeting = $greeter.SayHelloWithTime()

        # Assert
        $actualGreeting | Should -Be "Hello, World! @ MockedTime"
    }
}

Describe "Test Greeter class methods with mocking" {
    It "Should return the correct greeting with a custom greeting and name" {
        # Arrange
        $greeter = [Greeter]::new()
        $greeter.Greeting = "Hi"
        $greeter.Name = "Pester"

        # Pester cannot mock class methods directly, so only we can do is inspect the internal implementation of the class.
        # Mock the Get-Date cmdlet implementation since GetCurrentTime method calling it internally.
        Mock -CommandName Get-Date -MockWith { return "MockedTime" }

        # Act
        $actualGreeting = $greeter.SayHelloWithTime()

        # Assert
        $actualGreeting | Should -Be "Hi, Pester! @ MockedTime"
    }
}