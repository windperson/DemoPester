#Requires -Version 5.1

class Greeter {
    [string] $Greeting = "Hello"
    [string] $Name = "World"

    [string] SayHello() {
        return "$($this.Greeting), $($this.Name)!"
    }
    [string] SayHelloWithTime() {
        return "$($this.Greeting), $($this.Name)! @ $($this.GetCurrentTime())"
    }

    hidden [string] GetCurrentTime() {
        return Get-Date
    }
}
