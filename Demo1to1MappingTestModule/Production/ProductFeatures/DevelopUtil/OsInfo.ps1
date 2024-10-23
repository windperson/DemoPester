function Get-OSInfo {
    if ( $IsWindows) {
        $cim = Get-CimInstance -ClassName Win32_OperatingSystem
        $osInfo = @{
            OSName       = $cim.Caption
            Version      = $cim.Version
            Build        = $cim.BuildNumber
            Architecture = $cim.OSArchitecture
        }
    }
    elseif ( $IsLinux ) {
        if (Get-Command hostnamectl) {
            $info = hostnamectl --json=short | ConvertFrom-Json
            $osName = $info.OperatingSystemPrettyName
        }
        else {
            $osName = uname -s
        }
        $osVersion = Select-String -Path /etc/*release -Pattern "VERSION=`"(.*)`"" | ForEach-Object { $_.Matches[0].Groups[1].Value }
        $osRelease = uname -r
        $arch = uname -p
        $osInfo = @{
            OSName       = $osName
            Version      = $osVersion
            Build        = $osRelease
            Architecture = $arch
        }
    }
    elseif ( $IsMacOS ) {
        $os_name = sw_vers --productName
        $os_version = sw_vers --productVersion
        $os_build = sw_vers --buildVersion
        $arch = sysctl -n machdep.cpu.brand_string
        $osInfo = @{
            OSName       = $os_name
            Version      = $os_version
            Build        = $os_build
            Architecture = $arch
        }
    }
    else {
        $osInfo = @{
            OSName       = ""
            Version      = ""
            Build        = ""
            Architecture = ""
        }
    }

    return $osInfo
}