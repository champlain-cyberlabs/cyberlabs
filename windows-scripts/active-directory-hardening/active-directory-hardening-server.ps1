<# 

.SYNOPSIS
ACTIVE DIRECTORY HARDENING LAB SERVER SCRIPT
AUTHOR: BRANDON WILBUR
DATE: 11/16/2020

Configures an environment for Active Directory Hardening Lab

.DESCRIPTION
This script will modify a preexisting ADDS environment on a Windows Server.

.NOTES
- Add domain user and domain admin
- Enable PowerShell Remoting
- log off of the computer

.EXAMPLE
.\active-directory-hardening-server.ps1

#>

### CONFIGURE ADDS ###

Import-Module ActiveDirectory

# Create a normal user

$LexPass = ConvertTo-SecureString "Supersecret!" -AsPlainText -Force
New-ADUser -Name "Lex" -SamAccountName "lex" -AccountPassword $LexPass -Enabled 1

# Create a domain administrator

$AangPass = ConvertTo-SecureString "Avatar1!" -AsPlainText -Force
New-ADUser -Name "Aang" -SamAccountName "aang" -AccountPassword $AangPass -Enabled 1
Add-ADGroupMember -Identity "Domain Admins" -Members "aang"


### ENABLE POWERSHELL REMOTING ###

Enable-PSRemoting -Force


### LOGOUT ###

logoff

<# REFERENCES
- https://cloudblogs.microsoft.com/industry-blog/en-gb/technetuk/2016/06/08/setting-up-active-directory-via-powershell/
#>