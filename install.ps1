Set-ExecutionPolicy Unrestricted -Force
$ErrorActionPreference = "Stop"

$CompletedSteps = @{
    'InstalledPowershell' = $false
    'EnabledWsl'          = $false
    'InstalledAll'        = $false
}
$RegistryRoot = 'HKCU:\Software\Scripts\Setup'

function Set-Run {
    $Command = 'powershell -Command "Start-Process PowerShell -Verb RunAs -ArgumentList ''-noexit -file ' + $PSCommandPath + '''"'
    $KeyPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' 
    # The exclamation point tells us to retry if the script fails
    # https://learn.microsoft.com/en-us/windows/win32/setupapi/run-and-runonce-registry-keys
    $Name = 'SetupScript' 

    $Properties = Get-ItemProperty -Path $KeyPath
    if (-not (($Properties).$Name)) {
        New-ItemProperty -Path $KeyPath -Name $Name -Value $Command 
    }
    else {
        Set-ItemProperty -Path $KeyPath -Name $Name -Value $Command
    }
}

function Remove-Run {
    $KeyPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' 
    $Name = 'SetupScript' 

    Remove-ItemProperty -Path $KeyPath -Name $Name
}

function Get-Initial-Completed-Steps {
    $RegistryPath = $RegistryRoot + '\Completed'
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath
    }

    $Steps = Get-ItemProperty -Path $RegistryPath
    $CompletedSteps['InstalledPowershell'] = [bool]$Steps.InstalledPowershell
    $CompletedSteps['EnabledWsl'] = [bool]$Steps.EnabledWsl
    $CompletedSteps['InstalledAll'] = [bool]$Steps.InstalledAll
}

function Set-Completed-Step {
    param ([String] $Step)

    $RegistryPath = $RegistryRoot + '\Completed'
    If (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    $Value = '1'
    New-ItemProperty -Path $RegistryPath -Name $Step -Value $Value -PropertyType DWORD -Force 
}

function Install-Choco {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Powershell {
    if ($CompletedSteps.InstalledPowershell) {
        Write-Output "Powershell already installed"
        return
    }
    Write-Output "Updating powershell and restarting"
    choco install --yes powershell-core
    Set-Completed-Step "InstalledPowershell"
    Restart-Computer -Force
}

function Set-File-Extension-Config {
    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced

    Set-ItemProperty . HideFileExt "0"
    Set-ItemProperty . Hidden "1"

    # Force Windows Explorer restart so settings take effect
    Stop-Process -processName: Explorer -force
    Pop-Location
}

function Install-Choco-Package {
    param ([String] $Package)

    choco install --yes --limit-output $Package
    if ($LastExitCode -ne 0) {
        Write-Error "Failed to install $Package $LastErrorMessage"
        exit 1
    }
}

function Install-Choco-Packages {
    Write-Output "Installing general programs"
    Install-Choco-Package firefox
    Install-Choco-Package googlechrome
    Install-Choco-Package 1password
    Install-Choco-Package 1password-cli
    Install-Choco-Package zoom
    Install-Choco-Package spotify
    Install-Choco-Package discord
    Install-Choco-Package slack
    Install-Choco-Package 7zip
    Install-Choco-Package shutup10
    Install-Choco-Package mullvad-app
    Install-Choco-Package todoist-desktop
    Install-Choco-Package tree
    
    Write-Output "Installing coding programs"
    Install-Choco-Package vscode
    Install-Choco-Package jetbrainstoolbox
    Install-Choco-Package jetbrains-rider
    Install-Choco-Package intellijidea-ultimate
    Install-Choco-Package git
    Install-Choco-Package ripgrep
    Install-Choco-Package visualstudio2022community
    Install-Choco-Package cmder
    Install-Choco-Package wireshark
    Install-Choco-Package python
    Install-Choco-Package tableplus
    Install-Choco-Package postman 
    Install-Choco-Package dotnet
    Install-Choco-Package github-desktop
    Install-Choco-Package curl
    Install-Choco-Package vim

    Write-Output "Installing gaming programs"
    Install-Choco-Package steam
    Install-Choco-Package epicgameslauncher
    Install-Choco-Package unity-hub

    RefreshEnv
    Write-Output "Installing vscode extensiosn"
    code --install-extension vscodevim.vim --install-extension ms-vscode.powershell --install-extension foxundermoon.shell-format --install-extension bradlc.vscode-tailwindcss --install-extension github.copilot --install-extension jdinhlife.gruvbox
}

function Set-Git-Config {
    git config --global user.email "william.t.hammond@gmail.com"
    git config --global user.name "WilliamHammond"
}

function Install-Windows10Debloater {
    $Name = 'Debloated'
    $RegistryPath = $RegistryRoot + '\' + $Name
    If ((Test-Path $RegistryPath)) {
        Write-Output "Windows10Debloater already installed"
        return
    }  

    Push-Location
    Write-Output "Installing Windows10Debloater"
    New-Item -Path $RegistryPath -Force | Out-Null
    $Value = '1'
    New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force 

    Set-Location $env:TEMP
    $Windows10DebloaterZip = $env:TEMP + "\" + "Windows10Debloater.zip"
    Invoke-RestMethod -Uri https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip -OutFile $Windows10DebloaterZip
    Expand-Archive -Force $Windows10DebloaterZip

    $Windows10DebloaterExe = $env:TEMP + "\" + "Windows10SysPrepDebloater.ps1"
    $DebloaterProcess = Start-Process -PassThru powershell -ArgumentList $Windows10DebloaterExe '-Sysprep', '-Debloat', '-Privacy'
    Wait-Process $DebloaterProcess.ID -Timeout 600
    Pop-Location 
}

function Install-Dotnet-Packages {
    dotnet tool install csharpier --global
    dotnet tool install --global Microsoft.dotnet-interactive
}

function Install-Docker {
    Write-Output "Setting up WSL and Docker"
    if (!$CompletedSteps.EnabledWsl) {
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
        Set-Completed-Step "EnabledWsl"
        Restart-Computer -Force
    }

    Install-Choco-Package docker-for-windows
    Install-Choco-Package vscode-docker
    RefreshEnv

    wsl --install
    wsl --set-default-version 2

    winget install "ubuntu" --source msstore --silent --accept-package-agreements
}

Get-Initial-Completed-Steps
if ($CompletedSteps.InstalledAll) { 
    Write-Output "All steps already completed"
    Remove-Run 
    exit 0
}

Set-Run
Install-Choco
Install-Powershell
Set-File-Extension-Config 
Install-Choco-Packages
Set-Git-Config
Install-Windows10Debloater
Install-Docker
Install-Dotnet-Packages
Set-Completed-Step "InstalledAll"
Restart-Computer -Force
