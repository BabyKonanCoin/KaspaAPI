function Invoke-KasMenu {
    <#
    .SYNOPSIS
    Hosts the looping menu.

    .DESCRIPTION
    This function hosts the menu, processes user input, and performs actions based on the user's choices.
    #>
    # Get the directory path and config file
    $kaspaAppDataPath = Get-KasAppDataPath
    $configDir = Join-Path -Path $kaspaAppDataPath -ChildPath "Config"
    $configFile = Join-Path -Path $configDir -ChildPath "api_versions.json"

    # Ensure the Config directory exists
    if (-not (Test-Path -Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }

    # Load existing API versions or start with defaults
    $apiVersions = @{
        KasplexAPI = "https://api.kasplex.org/v1";        # Default KasplexAPI URL
        KaspaExplorerAPI = "https://explorer.kaspa.org"; # Default KaspaExplorerAPI URL
    }
    if (Test-Path -Path $configFile) {
        try {
            $apiVersions = Get-Content -Path $configFile | ConvertFrom-Json
        } catch {
            Write-Warning "Failed to load existing API versions. Starting with defaults."
        }
    }

    # Main menu loop
    do {
        # Display the menu
        Get-KasBanner
        Show-KasMenu

        # Wait for user input
        $choice = Read-Host

        switch ($choice) {
            1 {
                # View current API versions
                Write-Host "`nCurrent API Versions:" -ForegroundColor Cyan
                Write-Host "KasplexAPI: $($apiVersions.KasplexAPI)" -ForegroundColor White
                Write-Host "KaspaExplorerAPI: $($apiVersions.KaspaExplorerAPI)" -ForegroundColor White
                PauseMenu
            }
            2 {
                # Set KasplexAPI version
                Write-Host "`nAvailable KasplexAPI Endpoints:"
                Write-Host "1. https://api.kasplex.org/v1"
                Write-Host "2. https://tn10api.kasplex.org/v1"
                Write-Host "3. Enter your own custom URL"
                $option = Read-Host "Select KasplexAPI Endpoint (1, 2, or 3)"
                switch ($option) {
                    1 { $apiVersions.KasplexAPI = "https://api.kasplex.org/v1" }
                    2 { $apiVersions.KasplexAPI = "https://tn10api.kasplex.org/v1" }
                    3 {
                        $customURL = Read-Host "Enter your custom KasplexAPI URL"
                        if ($customURL -match "^https?://") {
                            $apiVersions.KasplexAPI = $customURL
                            Write-Host "KasplexAPI set to '$customURL'" -ForegroundColor Green
                        } else {
                            Write-Host "Invalid URL format. No changes made." -ForegroundColor Red
                        }
                    }
                    Default { Write-Host "Invalid choice. No changes made." -ForegroundColor Red }
                }
                PauseMenu
            }
            3 {
                # Set KaspaExplorerAPI version
                Write-Host "`nAvailable KaspaExplorerAPI Endpoints:"
                Write-Host "1. https://explorer.kaspa.org/"
                Write-Host "2. https://explorer-tn11.kaspa.org/"
                Write-Host "3. Enter your own custom URL"
                $option = Read-Host "Select KaspaExplorerAPI Endpoint (1, 2, or 3)"
                switch ($option) {
                    1 { $apiVersions.KaspaExplorerAPI = "https://explorer.kaspa.org/" }
                    2 { $apiVersions.KaspaExplorerAPI = "https://explorer-tn11.kaspa.org/" }
                    3 {
                        $customURL = Read-Host "Enter your custom KaspaExplorerAPI URL"
                        if ($customURL -match "^https?://") {
                            $apiVersions.KaspaExplorerAPI = $customURL
                            Write-Host "KaspaExplorerAPI set to '$customURL'" -ForegroundColor Green
                        } else {
                            Write-Host "Invalid URL format. No changes made." -ForegroundColor Red
                        }
                    }
                    Default { Write-Host "Invalid choice. No changes made." -ForegroundColor Red }
                }
                PauseMenu
            }
            0 {
                # Confirm changes and save
                Write-Host "`nConfirm the following changes:" -ForegroundColor Cyan
                Write-Host "KasplexAPI: $($apiVersions.KasplexAPI)" -ForegroundColor White
                Write-Host "KaspaExplorerAPI: $($apiVersions.KaspaExplorerAPI)" -ForegroundColor White
                $confirm = Read-Host "Do you want to save these changes? (yes/no)"
                if ($confirm -eq "yes") {
                    try {
                        $apiVersions | ConvertTo-Json -Depth 10 | Set-Content -Path $configFile -Encoding UTF8
                        Write-Host "Changes saved to '$configFile'." -ForegroundColor Green
                        break
                    } catch {
                        Write-Error "Failed to save changes. Error: $_"
                    }
                } else {
                    Write-Host "Changes not saved. Returning to the menu..." -ForegroundColor Yellow
                }
                PauseMenu
            }
            q {
                # Quit without saving
                Write-Host "Exiting without saving changes. Goodbye!" -ForegroundColor Cyan
                break
            }
            Default {
                Write-Host "Invalid choice. Please select a valid option." -ForegroundColor Red
                PauseMenu
            }
        }
    } while ($choice -ne "q" -and $choice -ne "0")
}

function PauseMenu {
    Write-Host "`nPress any key to return to the menu..." -ForegroundColor Cyan
    [System.Console]::ReadKey($true) | Out-Null
}
