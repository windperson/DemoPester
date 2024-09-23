# Demo 1-to-1 Mapping Test Module

This project is a demo of how to use [Pester](https://github.com/pester/Pester) to run a well-organized PowerShell production scripts with 1-to-1 mapping test(s).

You need to [install Pester v5.x or above](https://pester.dev/docs/introduction/installation) to run the tests.

## Running the tests

Run the `Run-Test.ps1` script in this directory, if you need to inspect the details of running, you can run the following command:

```powershell
& {
    $oldVerbosePreference = $VerbosePreference
    $VerbosePreference = 'Continue'
    .\Run-Test.ps1
    $VerbosePreference = $oldVerbosePreference
}
```

## Develop the tests & production scripts

You can use [VSCode + PowerShell extension](https://learn.microsoft.com/powershell/scripting/dev-cross-plat/vscode/using-vscode) to develop the tests and production scripts, and this project use another 3rd party extension [Switch](https://marketplace.visualstudio.com/items?itemName=fxlipe115.switch) to quickly switch between the test and production scripts.