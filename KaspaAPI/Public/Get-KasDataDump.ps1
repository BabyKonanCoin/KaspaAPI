function Get-KasDataDump {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Object[]]$Data,    # Input type set to hashtable for consistency
        [Parameter(Mandatory = $true)]
        [string]$Path        # Full file path where the XML file will be saved
    )

    # Initialize variables in the Begin block
    Begin {
        $collectedData = @()  # Array to collect all incoming hashtable data
    }

    # Process each item in the pipeline and add it to the collection
    Process {
        # Convert each hashtable to [pscustomobject] for compatibility with Export-Clixml
        $collectedData += [pscustomobject]$Data
    }

    # Export the entire collection to a single csv file in the End block
    End {
        try {
            # Export all collected data to the specified file path
            $collectedData | Export-Csv -Path $Path
            Write-Verbose "All data successfully dumped to $Path"
        } catch {
            Write-Warning "Failed to export data to $Path. Error: $_"
        }
    }
}
