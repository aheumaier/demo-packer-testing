$VerbosePreference="Continue"

function ConfigureWinRM {
    Write-Output "INFO: setup.ps1: ConfigureWinRM"

    winrm set winrm/config/client '@{TrustedHosts="*"}'
    winrm quickconfig -q
    netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow
    New-NetFirewallRule -DisplayName 'WinRM' -Profile 'Public' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985
}

function InstallChocolatey {
    Write-Output "INFO: setup.ps1: InstallChocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    
    choco feature enable --name allowGlobalConfirmation
    choco feature disable --name showDownloadProgress
}

function InstallPackages {
    Write-Output "INFO: setup.ps1: InstallPackages"
    choco install python
    choco install vim
}

function Main {
    Write-Output "INFO: setup.ps1: Main"
    InstallChocolatey
    InstallPackages
    ConfigureWinRM
    Write-Output "INFO: setup.ps1: Finished sucessful"
}

Main
