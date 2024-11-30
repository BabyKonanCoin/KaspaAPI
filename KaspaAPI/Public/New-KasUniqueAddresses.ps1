function New-KasUniqueAddresses {
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputFilePath,           # Path to the input CSV file
        [Parameter(Mandatory = $true)]
        [string]$Tick,                    # Identifier for subfolder naming
        [string]$FileNamePrefix = "UniqueAddress"  # Prefix for the filename
    )

    # Generate the output file path using Get-KasDatedFileName
    $UAPath = Get-KasDatedFileName -FileNamePrefix $FileNamePrefix `
                                           -SubFolder "$($Tick)_UniqueAddresses" `
                                           -Format "CSV"

    # Optional verbose output for debugging
    if ($Verbose) {
        Write-Verbose "# Generated path for UniqueAddresses CSV: $UAPath"
    }

    # Check if the input file exists
    if (-not (Test-Path -Path $InputFilePath)) {
        Write-Output "Input file not found: $InputFilePath"
        return
    }

    # Initialize a HashSet to store unique addresses
    $uniqueAddresses = [System.Collections.Generic.HashSet[string]]::new()

    # Use StreamReader to read the file line-by-line
    try {
        $reader = [System.IO.StreamReader]::new($InputFilePath)

        while ($null -ne ($line = $reader.ReadLine())) {
            # Add each line to the HashSet; duplicates are ignored automatically
            [void]$uniqueAddresses.Add($line)
        }

        # Close the reader after reading the file
        $reader.Close()
    } catch {
        Write-Output "Error reading file: $_"
        return $null
    }

    # Write unique addresses to the generated CSV file path without sorting
    try {
        # Open StreamWriter to write output directly to the CSV without headers
        $writer = [System.IO.StreamWriter]::new($UAPath, $false, [System.Text.Encoding]::UTF8)

        foreach ($address in $uniqueAddresses) {
            # Write each address to the file directly, no additional headers or type information
            $writer.WriteLine($address)
        }

        # Close the writer after writing all addresses
        $writer.Close()

        Write-Output "Unique addresses have been saved"
    } catch {
        Write-Error "Error writing to output file: $_"
    }

    return $UAPath
}
