<# 

.SYNOPSIS
WEBSHELL SCRIPT
AUTHOR: BRANDON WILBUR
DATE: 10/19/2020

Configures environment for Webshell Lab

.DESCRIPTION
This script will configure a Windows Server to install IIS and will place webshells
into servable directories for remote access.

.NOTES
- Create new administrative user
- Install IIS Role and dependencies
- Disable Defender and add exclusion for web directory
- Populate web server directory with benign files and webshells
- Open up newly created uploads directory for uploader page to write files

.EXAMPLE
.\webshell.ps1

#>


### IMPORT RESOURCE SCRIPTS ###

. .\lab_resources.ps1
. .\lab_setup_functions.ps1

### ADD USER ###

$Password = ConvertTo-SecureString 'Passw0rd!' -AsPlainText -Force
New-LocalUser 'john' -FullName 'John' -Password $Password
Add-LocalGroupMember -Group 'Administrators' -Member 'john'


### INSTALL IIS AND DEPENDENCIES ###

Install-WindowsFeature -Name Web-Server -IncludeManagementTools
Install-WindowsFeature -Name Web-ASP
Install-WindowsFeature -Name Web-ASP-Net
Install-WindowsFeature -Name Web-ASP-Net45


### DISABLE DEFENDER ###

Set-MpPreference -DisableRealtimeMonitoring $true
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware' -Value '1' `
    -PropertyType DWORD -Force
Add-MpPreference -ExclusionPath 'C:\inetpub\wwwroot'


### POPULATE WEB SERVER WITH CONTENT ###

# Remove default documents

Remove-Item C:\inetpub\wwwroot\iisstart.htm
Remove-Item C:\inetpub\wwwroot\iisstart.png

# Make directories

New-Item -Path "C:\inetpub\wwwroot\" -Name "images" -ItemType "directory"
New-Item -Path "C:\inetpub\wwwroot\" -Name "training" -ItemType "directory"
New-Item -Path "C:\inetpub\wwwroot\" -Name "uploads" -ItemType "directory" 

# Give IIS Users write access to uploads directory

Add-WriteAccess -Directory "C:\inetpub\wwwroot\uploads" -Group "IIS_IUSRS"

# Benign files

Write-EncodedData -Path "C:\inetpub\wwwroot\images\" -Name "cyberpatriots.png" -EncodedData `
  $cyberpatriot_image_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\images\" -Name "console.jpg" -EncodedData $console_image_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\images\" -Name "laptop.jpg" -EncodedData $laptop_image_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\training\" -Name "training.html" -EncodedData $training_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\uploads\" -Name "angry.png" -EncodedData $uploads_angry_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\uploads\" -Name "uploader.aspx" -EncodedData `
  $uploads_uploader_aspx_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\uploads\" -Name "uploads.html" -EncodedData `
  $uploads_uploads_html_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\" -Name "overview.html" -EncodedData $overview_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\" -Name "index.html" -EncodedData $index_encoded

# WebShells:

Write-EncodedData -Path "C:\inetpub\wwwroot\uploads\" -Name "index.asp" -EncodedData $uploads_index_asp_encoded
Write-EncodedData -Path "C:\inetpub\wwwroot\uploads\" -Name "myfile.aspx" -EncodedData $uploads_myfile_aspx_encoded  


### RESTART SERVER ###

Restart-Computer


<# REFERENCES

- Webshell script slightly modified from here:
  https://github.com/tennc/webshell/blob/master/asp/webshell.asp
- Images obtained from here:
  https://www.uscyberpatriot.org/
- ASPX Spy webshell obtained here:
  https://github.com/tennc/webshell/blob/master/net-friend/aspx/aspxspy.aspx
#>