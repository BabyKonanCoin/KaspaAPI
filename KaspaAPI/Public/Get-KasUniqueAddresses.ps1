function Get-KasUniqueAddresses {
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFilePath           # Path to the input CSV file
    )

    # Check if the input file exists
    if (-not (Test-Path -Path $InputFilePath)) {
        Write-Output "Input file not found: $InputFilePath"
        return $null
    }

    # Initialize a HashSet to store unique addresses as strings
    $uniqueAddresses = [System.Collections.Generic.HashSet[string]]::new()

    # Use Import-Csv to read the CSV file, assuming the column is named "Address"
    try {
        $csvData = Import-Csv -Path $InputFilePath

        foreach ($row in $csvData) {
            # Add each address to the HashSet; suppress True/False output with [void]
            [void]$uniqueAddresses.Add($row.Address)
        }
    } catch {
        Write-Output "Error reading file: $_"
        return $null
    }

    # Convert the HashSet to an array and return it
    return @($uniqueAddresses)
}
