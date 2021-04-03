#Requires -RunAsAdministrator

function Set-LocalSecurityPolicy
{

    <# 

        .SYNOPSIS
        Set-LocalSecurityPolicy

        .DESCRIPTION
        Prompt the user to use the Local Security Policy editor to edit and export a local machine's security policy.
        After closing the local security policy editor, settings will be exported in plain text and Base64 format.

        The Base64-encoded variable holding the local security policy can be dropped to disk using the following .NET command.
        This is compatible within a PowerShell script, writing the contents of $EncodedSecPol to secpol.cfg:

        [IO.File]::WriteAllBytes("secpol.cfg", [Convert]::FromBase64String($EncodedSecPol))

        .EXAMPLE
        PS> Import-Module .\Set-LocalSecurityPolicy.psm1
        Set-LocalSecurityPolicy


    #>

    Write-Host "Opening Local Security Policy Editor. After making desired changes, close the editor to continue."
    Write-Host "Wait a few moments after closing the editor for the process to terminate."

    Start-Process "${env:windir}\System32\secpol.msc" -Wait

    $save_path = Read-Host -Prompt "Enter full path to the directory where security policies will be saved"

    while((Test-Path $save_path) -eq $False) {

        Write-Host "Invalid path."
        $save_path = Read-Host -Prompt "Enter full file path where security policies will be saved"
    }

    secedit /export /cfg "$save_path\secpol.cfg" /quiet

    Write-Host "`r`nPlain text security policy saved to $save_path\secpol.cfg."

    $EncodedSecpol = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$save_path\secpol.cfg"))

    New-Item -Path "$save_path\base64-encoded-policy.txt" -ItemType "file" -Value ('$EncodedSecpol = ' + $EncodedSecpol) | Out-Null

    Write-Host "Base64-encoded security policy saved to $save_path\base64-encoded-policy.txt.`r`n"

    Write-Host "Run Get-Help Set-LocalSecurityPolicy for more information on using this encoded file in a script."

}