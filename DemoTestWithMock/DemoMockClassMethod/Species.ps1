class Human {
    [Guid]
    hidden $ID = (New-Guid).Guid

    [ValidatePattern('^[a-z]')]
    [ValidateLength(3, 15)]
    [string]
    $Name

    [ValidateRange(1, 200)]
    [double]
    $Height

    [ValidateRange(0, 1000)]
    [double]
    $Weight

    Human() {
    }

    Human([string]$Name) {
        $this.Name = $Name
    }

    [void]Jump() {
        Write-Host "$($this.Name) is jumping"
        return
    }

    [string]SayHello() {
        return "Hello, I am $($this.Name)"
    }

    [string]SayHello([string]$Name) {
        return "Hello, $Name. I am $($this.Name)"
    }
}

class animal {
    [string]
    $Name

    [int]
    $Legs

    [int]
    $Age

    [double]
    $Weight

    [double]
    $Height

    animal() {
    }

    animal([string]$NewName) {
        $this.Name = $NewName
    }


    [string]Jump() {
        Return  "look at that $($this.ToString()) jump!"
    }

    [string]Speak() {
        Throw [System.NotImplementedException]::New('Speak method should be overridden in child class')
    }
}

class dog : animal {
    [double]
    $TailLength

    dog() {
    }

    dog([string]$Name) : base($Name) {
    }

    [int]AgeDogYears() {
        return $this.Age * 7
    }

    [string]Speak() {
        return "Woof!"
    }
}

class kangaroo : animal {
    [string]Jump() {
        $originalString = ([animal]$this).Jump()
        return $originalString * 2
    }
}