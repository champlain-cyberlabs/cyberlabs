<# 

.SYNOPSIS
UNNEEDED SOFTWARE
AUTHOR: BRANDON WILBUR
DATE: 4/2/2021

.DESCRIPTION
This script will configure a Windows 10 Workstation with unnecessary software that can be remediated through system hardening.

.NOTES
- Add users
- Download programs
- Install RSAT
- Install OpenSSH Server and Client
- Install Hyper-V
- Restart Computer

.EXAMPLE
.\software-auditing.ps1

#>

### INITIAL SETUP ###

# Hyper-V cannot be installed on Windows Home. $is_windows_home will be used later to determine what to install.

$os_type = Get-ComputerInfo | Select-Object -Property OsName
$is_windows_home = "Home" -Match $os_type

# Invoke-WebRequest is significantly faster with this variable set:

$ProgressPreference = 'SilentlyContinue'


### ADD USERS ###

$Password_Sheldon = ConvertTo-SecureString 'B0nes!' -AsPlainText -Force
New-LocalUser 'sheldon' -FullName 'Sheldon' -Password $Password_Sheldon
Add-LocalGroupMember -Group 'Users' -Member 'sheldon'

$Password_Stanley = ConvertTo-SecureString 'Wh0ishere!' -AsPlainText -Force
New-LocalUser 'stanley' -FullName 'Stanley' -Password $Password_Stanley
Add-LocalGroupMember -Group 'Administrators' -Member 'stanley'


### DOWNLOAD CHCOLATEY ###

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv.cmd


### INSTALL SOFTWARE VIA CHOCOLATEY ###

choco install -y teamviewer googlechrome firefox putty filezilla 7zip vlc notepadplusplus `
    adobereader git skype libreoffice-fresh thunderbird discord malwarebytes sysinternals `
    ccleaner wireshark youtube-dl qpdf everything trojan-remover 


### INSTALL RSAT ###

Get-WindowsCapability -Online -Name Rsat.ServerManager* | Select-Object -Property Name | ForEach-Object -Process {Add-WindowsCapability -Online -Name $_.Name}


### INSTALL OPENSSH SERVER ###

Get-WindowsCapability -Online -Name OpenSSH.Server* | Select-Object -Property Name | ForEach-Object -Process {Add-WindowsCapability -Online -Name $_.Name}


### INSTALL HYPERV ###

# Modify the below multi-line string to change the VM installed within Hyper-V.

$vm_creation_script=@'
# Download the ISO file for the VM:
Invoke-WebRequest -Uri 'http://www.tinycorelinux.net/12.x/x86/release/TinyCore-current.iso' -UseBasicParsing -OutFile "C:\Users\sheldon\Downloads\tinycore.iso"

# Set VM Name, Switch Name, and Installation Media Path.
$VMName = 'TinyLinux'
$InstallMedia = 'C:\Users\sheldon\Downloads\tinycore.iso'

# Create New Virtual Machine
New-VM -Name $VMName -MemoryStartupBytes 2147483648 -Generation 2 -NewVHDPath "C:\Users\sheldon\Documents\$VMName\$VMName.vhdx" -NewVHDSizeBytes 10737418240 -Path "C:\Users\sheldon\Documents\$VMName"

# Add DVD Drive to Virtual Machine
Add-VMScsiController -VMName $VMName
Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path $InstallMedia

# Mount Installation Media
$DVDDrive = Get-VMDvdDrive -VMName $VMName

# Configure Virtual Machine to Boot from DVD
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive

# Disable Scheduled Task used to run this script so it only runs once
Disable-ScheduledTask -TaskName "Create VM"
'@


if ($is_windows_home -eq $False) {

    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

    # This section will attempt to make a scheduled task to run the above script on system boot, not currently functional
    <#
    New-Item -Path "${env:windir}\Temp" -Name "create-vm.ps1" -ItemType "file" -Value $vm_creation_script

    $Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -File %WINDIR%\Temp\create-vm.ps1"
    $Trigger = New-ScheduledTaskTrigger -AtLogOn
    $Principal = New-ScheduledTaskPrincipal "${env:computername}\sheldon"
    $Settings = New-ScheduledTaskSettingsSet
    $Task_Definition = New-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings
    Register-ScheduledTask -TaskName "Create VM" -InputObject $Task_Definition
    #>
}

### RESTART COMPUTER ###

Restart-Computer


### REFERENCES ###
# https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine
# https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtask?view=windowsserver2019-ps