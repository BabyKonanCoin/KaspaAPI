function Update-Clixml {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,          # Path to the XML file

        [Parameter(Mandatory = $true)]
        $Data                    # Data to append (can be a single object or array of objects)
    )

    # Initialize array to hold all data
    $existingData = @()

    # Check if the file exists and import existing data if it does
    if (Test-Path -Path $Path) {
        try {
            $existingData = Import-Clixml -Path $Path
            # Ensure that $existingData is an array
            if ($existingData -isnot [System.Collections.IEnumerable]) {
                $existingData = @($existingData)
            }
        } catch {
            Write-Warning "Failed to import existing data from $Path. Error: $_"
            return
        }
    }

    # Append the new data
    if ($Data -is [System.Collections.IEnumerable]) {
        $existingData += $Data
    } else {
        $existingData += ,$Data  # Wrap in array to ensure single objects are appended correctly
    }

    # Export the combined data back to the XML file
    try {
        $existingData | Export-Clixml -Path $Path
        Write-Verbose "Data successfully appended to $Path"
    } catch {
        Write-Warning "Failed to export data to $Path. Error: $_"
    }
}

<#
# New data to append (can be an object or array of objects)
$newTransaction = [PSCustomObject]@{
    Address = "0x12345"
    Balance = 100
    Token = "KRC20"
}

# Call Append-Clixml to add to the XML file
Append-Clixml -Path "C:\path\to\transactions.xml" -Data $newTransaction

#>
