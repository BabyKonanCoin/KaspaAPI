function New-KasAppDataPath {
    <#
    .SYNOPSIS
    Creates a directory for KaspaAPI app data

    .DESCRIPTION
    This function, New-KasNew-KasAppDataPath, combines LOCALAPPDATA with a subdirectory
    specific to KaspaAPI module.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        $appDataRoot = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'KaspaAPI\'
        (New-Item -Path $appDataRoot -ItemType Directory -Force).FullName
    }
}
