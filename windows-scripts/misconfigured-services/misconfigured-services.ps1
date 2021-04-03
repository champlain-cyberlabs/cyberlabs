<# 

.SYNOPSIS
MISCONFIGURED SERVICES SCRIPT
AUTHOR: BRANDON WILBUR
DATE: 11/2/2020

Configures an environment for Misconfigured Services Lab

.DESCRIPTION
This script will configure a Windows 10 Workstation with unwanted services.

.NOTES
- Add users
- Install Chocolatey and install various pieces of software
- Install and misconfigure FTP Server
- Populate filesystem
- Create SMB Share
- Restart system

.EXAMPLE
.\misconfigured-services.ps1

#>

### IMPORT RESOURCE SCRIPTS ###

. .\lab_resources.ps1
. .\lab_setup_functions.ps1

### ADD USERS ###

$BillPassword = ConvertTo-SecureString 'Passw0rd!' -AsPlainText -Force
New-LocalUser 'bill' -FullName 'Bill' -Password $BillPassword
Add-LocalGroupMember -Group 'Administrators' -Member 'bill'

$LindaPassword = ConvertTo-SecureString 'SuperSecret!' -AsPlainText -Force
New-LocalUser 'linda' -FullName 'Linda' -Password $LindaPassword


### DOWNLOAD CHCOLATEY ###

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


### INSTALL BENIGN SOFTWARE ###

choco install -y googlechrome firefox putty filezilla 7zip vlc notepadplusplus `
    keepassx python3 adobereader git winpcap wireshark skype libreoffice-fresh thunderbird

refreshenv


### INSTALL AND MISCONFIGURE FTP ###

Enable-WindowsOptionalFeature -Online -FeatureName `
    'IIS-WebServerRole','IIS-FTPServer', 'IIS-WebServerManagementTools'

# The following FTP configuration commands were modified from Prateek Singh's guide linked below.

Import-Module WebAdministration

# Create the FTP site
$FTPSiteName = 'My Computer'
$FTPRootDir = 'C:\'
$FTPPort = 21
New-WebFtpSite -Name $FTPSiteName -Port $FTPPort -PhysicalPath $FTPRootDir

# Create the local Windows group
$FTPUserGroupName = "FTP Users"
$ADSI = [ADSI]"WinNT://$env:ComputerName"
$FTPUserGroup = $ADSI.Create("Group", "$FTPUserGroupName")
$FTPUserGroup.SetInfo()
$FTPUserGroup.Description = "Members of this group can connect through FTP"
$FTPUserGroup.SetInfo()

# Add an FTP user to the group FTP Users
$FTPUserName = 'bill'
$UserAccount = New-Object System.Security.Principal.NTAccount("$FTPUserName")
$SID = $UserAccount.Translate([System.Security.Principal.SecurityIdentifier])
$Group = [ADSI]"WinNT://$env:ComputerName/$FTPUserGroupName,Group"
$User = [ADSI]"WinNT://$SID"
$Group.Add($User.Path)

$FTPUserName = 'linda'
$UserAccount = New-Object System.Security.Principal.NTAccount("$FTPUserName")
$SID = $UserAccount.Translate([System.Security.Principal.SecurityIdentifier])
$Group = [ADSI]"WinNT://$env:ComputerName/$FTPUserGroupName,Group"
$User = [ADSI]"WinNT://$SID"
$Group.Add($User.Path)

# Enable basic authentication on the FTP site
$FTPSitePath = "IIS:\Sites\$FTPSiteName"
$BasicAuth = 'ftpServer.security.authentication.basicAuthentication.enabled'
Set-ItemProperty -Path $FTPSitePath -Name $BasicAuth -Value $True
# Add an authorization read rule for FTP Users.
$Param = @{
    Filter   = "/system.ftpServer/security/authorization"
    Value    = @{
        accessType  = "Allow"
        roles       = "$FTPUserGroupName"
        permissions = 1
    }
    PSPath   = 'IIS:\'
    Location = $FTPSiteName
}
Add-WebConfiguration @param

$SSLPolicy = @(
    'ftpServer.security.ssl.controlChannelPolicy',
    'ftpServer.security.ssl.dataChannelPolicy'
)
Set-ItemProperty -Path $FTPSitePath -Name $SSLPolicy[0] -Value $false
Set-ItemProperty -Path $FTPSitePath -Name $SSLPolicy[1] -Value $false

$UserAccount = New-Object System.Security.Principal.NTAccount("$FTPUserGroupName")
$AccessRule = [System.Security.AccessControl.FileSystemAccessRule]::new($UserAccount,
    'ReadAndExecute',
    'ContainerInherit,ObjectInherit',
    'None',
    'Allow'
)
$ACL = Get-Acl -Path $FTPRootDir
$ACL.SetAccessRule($AccessRule)
$ACL | Set-Acl -Path $FTPRootDir

# Restart the FTP site for all changes to take effect
Restart-WebItem "IIS:\Sites\$FTPSiteName" -Verbose

# Firewall Rules to allow FTP Server to communicate to outside clients
Enable-NetFirewallRule -Name 'IIS-WebServerRole-FTP-In-TCP-21'
Enable-NetFirewallRule -Name 'IIS-WebServerRole-FTP-Out-TCP-20'
Enable-NetFirewallRule -Name 'IIS-WebServerRole-FTP-Passive-In-TCP'
Enable-NetFirewallRule -Name 'FTP Server Passive (FTP Passive Traffic-In)'
Enable-NetFirewallRule -Name 'FTP Server (FTP Traffic-Out)'
Enable-NetFirewallRule -Name 'FTP Server (FTP Traffic-In)'


### POPULATE FILESYSTEM ###

# Create directories

New-Item -Path 'C:\' -Name 'Files' -ItemType 'directory'
New-Item -Path 'C:\Files\' -Name 'Financial' -ItemType 'directory'
New-Item -Path 'C:\Files\' -Name 'IT' -ItemType 'directory'
New-Item -Path 'C:\Files\' -Name 'Lunch' -ItemType 'directory'

# Write Files

Write-EncodedData -Path 'C:\Files\Financial\' -Name 'Annual Report.odp' -EncodedData $annual_report
Write-EncodedData -Path 'C:\Files\Financial\' -Name 'Payment Information.ods' -EncodedData $payment_information
Write-EncodedData -Path 'C:\Files\IT\' -Name 'passwords.kbdx' -EncodedData $passwords
Write-EncodedData -Path 'C:\Files\IT\' -Name 'PowerShell.pdf' -EncodedData $powershell
Write-EncodedData -Path 'C:\Files\IT\' -Name 'todo.odt' -EncodedData $todo
Write-EncodedData -Path 'C:\Files\Lunch\' -Name 'mmm.jpg' -EncodedData $mmm


### CREATE SMB SHARE ###

New-SmbShare -Name 'Files' -Path 'C:\Files\' -FullAccess 'Everyone'


### RESTART COMPUTER ###

Restart-Computer


<# REFERENCES
- https://4sysops.com/archives/install-and-configure-an-ftp-server-with-powershell/
#>