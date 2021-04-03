function Write-EncodedData {

    <#
        .SYNOPSIS
        Writes data in a Base64 encoded string to a new file.

        .PARAMETER Path
        Specifies the full path to the new file being created.

        .PARAMETER EncodedData
        Specifies the Base64 encoded data to write to the file.

        .PARAMETER Name
        Specifies the new file name.

        .EXAMPLE
        Write-EncodedData -Path "C:\" -Name "hello.txt" -EncodedData "d29ybGQ="
    #>

    param (
        $Path,
        $EncodedData,
        $Name
    )

    $decoded_data = [Convert]::FromBase64String($EncodedData)
    New-Item -Path $Path -Name $Name -ItemType "file"
    [IO.File]::WriteAllBytes($Path + $Name, $decoded_data)
}

function Add-WriteAccess {

    <#

        .SYNOPSIS
        Grants write access to a directory for a specified group.

        .PARAMETER Directory
        Specifies the directory to grant write access to.

        .PARAMETER Group
        Specifies the group to grant write access to.

        .EXAMPLE
        Add-WriteAccess -Directory "C:\uploads" -Group "IIS_IUSRS"

    #>

    param(
        $Directory,
        $Group
        )

    $Acl = Get-Acl $Directory
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Group, "Write", `
        "ContainerInherit,ObjectInherit", "None", "Allow")
    $Acl.SetAccessRule($AccessRule)
    Set-Acl $Directory $Acl
}