function Get-KasAPIVersions {
    <#
    .SYNOPSIS
    Loads API versions from the JSON file in the Config directory.

    .DESCRIPTION
    This function retrieves the `api_versions.json` file stored in the `Config` directory under the KaspaAPI application data path.
    If the file does not exist, it creates a default JSON file with standard API URLs.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]

    param()

    process {
        # Get the AppData path and the Config directory
        $appDataPath = Get-KasAppDataPath
        $configDir = Join-Path -Path $appDataPath -ChildPath "Config"
        $configFile = Join-Path -Path $configDir -ChildPath "api_versions.json"

        # Ensure the Config directory exists
        if (-not (Test-Path -Path $configDir)) {
            New-Item -ItemType Directory -Path $configDir -Force | Out-Null
        }

        # Default API versions
        $defaultAPIVersions = @{
            KaspaExplorerAPI = "https://explorer.kaspa.org/"
            KasplexAPI = "https://api.kasplex.org/v1"
        }

        # Check if the JSON file exists
        if (-not (Test-Path -Path $configFile)) {
            # Create the default JSON file
            $defaultAPIVersions | ConvertTo-Json -Depth 10 | Set-Content -Path $configFile -Encoding UTF8
            Write-Host "Default API versions file created at '$configFile'." -ForegroundColor Green
        }

        # Load the JSON file
        try {
            $apiVersions = Get-Content -Path $configFile | ConvertFrom-Json
            return $apiVersions
        } catch {
            Write-Error "Failed to load API versions from '$configFile'. Error: $_"
            return $null
        }
    }
}
