<# 

.SYNOPSIS
ACTIVE DIRECTORY HARDENING LAB CLIENT SCRIPT
AUTHOR: BRANDON WILBUR
DATE: 11/16/2020

Configures an environment for Active Directory Hardening Lab

.DESCRIPTION
This script will leave a domain-joined Windows 10 workstation vulnerable. Ensure that the joined domain
is named student.local.

.NOTES
- Disable Windows Defender
- Misconfigure WDigest to store cleartext credentials in memory
- Download Mimikatz
- Make all domain users local admins
- Enable RDP
- Restart the computer

.EXAMPLE
.\active-directory-hardening-workstation.ps1

#>

### DISABLE DEFENDER ###

Set-MpPreference -DisableRealtimeMonitoring $true
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware' -Value '1' `
    -PropertyType DWORD -Force
Add-MpPreference -ExclusionPath 'C:\'


### MISCONFIGURE WDIGEST ###

New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\SecurityProviders\WDigest' -Name `
    'UseLogonCredential' -Value '1' -PropertyType DWORD -Force


### DOWNLOAD TOOLS ###

# Download Mimikatz
Invoke-WebRequest -Uri `
    'https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200918-fix/mimikatz_trunk.zip' `
        -OutFile 'C:\Windows\Temp\m.zip' -UseBasicParsing
New-Item -Path 'C:\Users\Public\Desktop\' -Name 'mimikatz' -ItemType 'directory'
Expand-Archive -LiteralPath 'C:\Windows\Temp\m.zip' -DestinationPath 'C:\Users\Public\Desktop\mimikatz'
Remove-Item 'C:\Windows\Temp\m.zip'


### MAKE DOMAIN USERS LOCAL ADMINS ###

Add-LocalGroupMember -Group 'Administrators' -Member 'STUDENT\Domain Users'


### ENABLE RDP ###

Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name `
    'UserAuthentication' -Value 1


### RESTART COMPUTER ###

Restart-Computer


<# REFERENCES
- https://support.microsoft.com/en-us/help/2871997/microsoft-security-advisory-update-to-improve-credentials-protection-a
- https://vmarena.com/how-to-enable-remote-desktop-rdp-remotely-using-powershell/
#>