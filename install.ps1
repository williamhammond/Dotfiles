Set-ExecutionPolicy Unrestricted -Force


Install-Choco

Write-Output "Updating powershell and restarting"
choco install --yes powershell-core

Restart-Computer -Confirm
Set-File-Extension-Config 
Install-Choco-Packages
Set-Git-Config
Install-Windows10Debloater
Install-Docker

Restart-Computer -Confirm

function Install-Choco {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
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

function Install-Choco-Packages {
    Write-Output "Installing general programs"
    choco install --yes firefox
    choco install --yes googlechrome
    choco install --yes 1password
    choco install --yes 1password-cli
    choco install --yes zoom
    choco install --yes spotify
    choco install --yes discord
    choco install --yes slack
    choco install --yes 7zip
    choco install --yes shutup10
    choco install --yes mullvad-app
    choco install --yes todoist-desktop
    choco install --yes tree

    Write-Output "Installing coding programs"
    choco install --yes vscode
    choco install --yes jetbrainstoolbox
    choco install --yes jetbrains-rider
    choco install --yes intellijidea-ultimate
    choco install --yes git
    choco install --yes ripgrep
    choco install --yes visualstudio2022community
    choco install --yes cmder
    choco install --yes wireshark
    choco install --yes python
    choco install --yes pip 
    choco install --yes jdk11
    choco install --yes tableplus
    choco install --yes postman 
    choco install --yes dotnet
    choco install --yes github-desktop
    choco install --yes curl

    Write-Output "Installing gaming programs"
    choco install --yes steam
    choco install --yes epicgameslauncher
    choco install --yes unity-hub

    RefreshEnv
    Write-Output "Installing vscode extensiosn"
    code --install-extension vscodevim.vim --install-extension ms-vscode.powershell --install-extension foxundermoon.shell-format --install-extension bradlc.vscode-tailwindcss --install-extension github.copilot --install-extension jdinhlife.gruvbox
}

function Set-Git-Config {
    git config --global user.email "william.t.hammond@gmail.com"
    git config --global user.name "WilliamHammond"
    ssh-keygen
}

function Install-Windows10Debloater {
    Write-Output "Installing Windows10Debloater"
    Push-Location
    Set-Location $env:TEMP
    $Windows10DebloaterZip = $env:TEMP + "\" + "Windows10Debloater.zip"
    Invoke-RestMethod -Uri https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip -OutFile $Windows10DebloaterZip
    Expand-Archive $Windows10DebloaterPath

    $Windows10DebloaterExe = $env:TEMP + "\" + "Windows10SysPrepDebloater.ps1"
    $DebloaterProcess = Start-Process -PassThru powershell -ArgumentList $Windows10DebloaterExe, "-Sysprep", "-Debloat", "-Privacy"
    Wait-Process $DebloaterProcess.ID -Timeout 600
    Pop-Location 
}

function Install-Dotnet-Packages {
    dotnet tool install csharpier -g
}

function Install-Docker {
    Write-Output "Setting up WSL and Docker"
    Push-Location
    Enable-WindowsOptionalFeature -Online -FeatureName containers -All
    choco install --yes docker-for-windows
    choco install --yes vscode-docker
    choco install --yes Microsoft-Hyper-V-All --source="'windowsFeatures'"

    RefreshEnv
    wsl --install
    wsl --set-default-version 2

    $UbuntuZip = $env:TEMP + "\" + "Ubuntu2004.zip"
    Invoke-RestMethod -Uri https://aka.ms/wslubuntu2004 -OutFile $UbuntuZip
    Expand-Archive $UbuntuZip ubuntu
    $UserEnv = [System.Environment]::GetEnvironmentVariable("Path", "User")
    [System.Environment]::SetEnvironmentVariable("PATH", $UserEnv + (get-location) + "\ubuntu", "User")
    .\ubuntu\ubuntu2004.exe
    Push-Location
}
