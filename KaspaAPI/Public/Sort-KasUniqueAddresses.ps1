function Import-KasUniqueAddresses {
    <#
    .SYNOPSIS
    Retrieves unique addresses from a CSV file.

    .DESCRIPTION
    This function reads a CSV file to extract unique addresses from the "Address" column.
    If the `-InputFilePath` parameter is not provided, a file selection dialog is displayed to choose the input file.
    It shows progress while processing each address and writes the total count of unique addresses.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$InputFilePath           # Optional path to the input CSV file
    )

    process {
        # Load assembly for file dialog (if needed)
        Add-Type -AssemblyName System.Windows.Forms

        # Open file dialog if InputFilePath is not provided
        if (-not $InputFilePath) {
            # Get the default application data path
            $defaultPath = Get-KasAppDataPath

            # Open file dialog
            $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
            $fileDialog.InitialDirectory = $defaultPath
            $fileDialog.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
            $fileDialog.Title = "Select the Input CSV File"

            if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                $InputFilePath = $fileDialog.FileName
            } else {
                Write-Warning "No file was selected. Operation canceled."
                return $null
            }
        }

        # Check if the input file exists
        if (-not (Test-Path -Path $InputFilePath)) {
            Write-Warning "Input file not found: $InputFilePath"
            return $null
        }

        # Initialize a HashSet to store unique addresses as strings
        $uniqueAddresses = [System.Collections.Generic.HashSet[string]]::new()

        # Use Import-Csv to read the CSV file, assuming the column is named "Address"
        try {
            $csvData = Import-Csv -Path $InputFilePath

            # Track the total number of rows
            $totalRows = $csvData.Count
            $currentRow = 0

            foreach ($row in $csvData) {
                # Update progress
                $currentRow++
                Write-Progress -Activity "Processing Addresses" `
                               -Status "Processing address $currentRow of $totalRows" `
                               -PercentComplete (($currentRow / $totalRows) * 100)

                # Add each address to the HashSet; suppress True/False output with [void]
                [void]$uniqueAddresses.Add($row.Address)
            }

            # Write total unique addresses count
            Write-Host "Total unique addresses: $($uniqueAddresses.Count)"
        } catch {
            Write-Error "Error reading file: $_"
            return $null
        }

        # Convert the HashSet to an array and return it
        return @($uniqueAddresses)
    }
}
