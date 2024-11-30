function Import-KasAddressPool {
    <#
    .SYNOPSIS
    Imports a pool of addresses from a CSV file.

    .DESCRIPTION
    This function imports a pool of addresses from a CSV file. You can either
    provide the file path directly via the `-FilePath` parameter or use a file
    selection dialog to choose the file. The function extracts only the
    `address` field from the CSV and returns the addresses while displaying
    their count.
    #>
    [CmdletBinding()]
    param(
        # Optional file path to a CSV file
        [string]$FilePath
    )

    process {
        # Load assembly for file dialog (if needed)
        Add-Type -AssemblyName System.Windows.Forms

        # Check if the file path is provided; if not, show the dialog
        if (-not $FilePath) {
            # Get the default application data path
            $defaultPath = Get-KasAppDataPath

            # Open file dialog
            $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
            $fileDialog.InitialDirectory = $defaultPath
            $fileDialog.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
            $fileDialog.Title = "Select the Address Pool CSV File"

            if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                $FilePath = $fileDialog.FileName
            } else {
                Write-Warning "No file was selected. Operation canceled."
                return
            }
        }

        # Import the CSV file
        try {
            $data = Import-Csv -Path $FilePath

            # Extract only the addresses
            $addresses = $data | Select-Object -ExpandProperty address

            # Return the addresses and their count
            Write-Host "Total addresses imported: $($addresses.Count)"

            return $addresses
        } catch {
            Write-Error "Failed to import the file. Ensure the file format is correct. Error: $_"
        }
    }
}
