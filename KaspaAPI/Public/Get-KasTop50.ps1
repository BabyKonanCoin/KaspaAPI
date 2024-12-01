function Get-KasTop50 {
    <#
    .SYNOPSIS
    Retrieves top 50 data for a given token tick from Kasplex API and optionally exports the results to a CSV file.

    .DESCRIPTION
    This function validates the input tick symbol to ensure it is between 4 and 6 characters in length.
    It fetches data from the Kasplex API for the specified token tick and can return either the full API data or
    only the addresses of the top 50 holders. Use `-FilePath` or `-SelectPathToExport` for exporting results to a CSV file.
    The parameters `-FilePath` and `-SelectPathToExport` are mutually exclusive.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(4, 6)] # Validates the length of the Tick parameter
        [string]$Tick,

        [Parameter(Mandatory = $false)]
        [switch]$ReturnAddressesOnly,

        [Parameter(Mandatory = $false)]
        [string]$FilePath, # Optional file path for saving results

        [Parameter(Mandatory = $false)]
        [switch]$SelectPathToExport # Prompts for save location if specified
    )

    process {
        try {
            # Load assembly for file dialog (if needed)
            Add-Type -AssemblyName System.Windows.Forms

            # Construct the API URI
            $kasplexApiUri = "$script:KasplexAPI/krc20/token/$tick"

            # Fetch the data from the Kasplex API
            $kasplexData = Invoke-RestMethod -Uri $kasplexApiUri

            if ($ReturnAddressesOnly) {
                # Extract top 50 addresses
                $top50Addresses = ($kasplexData.result.holder) | Select-Object -Property Address

                # If SelectPathToExport is specified, open the file save dialog
                if ($SelectPathToExport) {
                    $fileDialog = New-Object System.Windows.Forms.SaveFileDialog
                    $fileDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
                    $fileDialog.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
                    $fileDialog.Title = "Select File Path to Save Addresses as CSV"

                    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                        $FilePath = $fileDialog.FileName
                    } else {
                        Write-Warning "No file path selected. Operation canceled."
                        return
                    }
                }

                # Export addresses to CSV if a valid FilePath is provided
                if (-not [string]::IsNullOrWhiteSpace($FilePath)) {
                    $top50Addresses | Export-Csv -Path $FilePath -NoTypeInformation -Encoding UTF8
                    Write-Host "Top 50 addresses exported to CSV at $FilePath"
                }

                # Return the addresses
                return $top50Addresses
            } else {
                # Export the full data to CSV if requested
                if ($SelectPathToExport) {
                    $fileDialog = New-Object System.Windows.Forms.SaveFileDialog
                    $fileDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
                    $fileDialog.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
                    $fileDialog.Title = "Select File Path to Save Full Data as CSV"

                    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                        $FilePath = $fileDialog.FileName
                    } else {
                        Write-Warning "No file path selected. Operation canceled."
                        return
                    }
                }

                if (-not [string]::IsNullOrWhiteSpace($FilePath)) {
                    $kasplexData.result.holder | Export-Csv -Path $FilePath -NoTypeInformation -Encoding UTF8
                    Write-Host "Full data exported to CSV at $FilePath"
                }

                # Return the full API response
                return $kasplexData
            }

        } catch {
            Write-Error "Failed to fetch data from Kasplex API. Error: $_"
        }
    }
}
