function Get-KasTx {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Address, # Input address

        [Parameter(Mandatory = $true)]
        [ValidateSet("Transactions", "UniqueAddresses", "All")]
        [string]$OutputType,  # Enables collection of unique addresses

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 50)]
        [int]$Limit = 50,  # Default limit for paginated retrieval

        [Parameter(Mandatory = $false)]
        [Int64]$Before,  # Initial "before" parameter, default is 0 to start with the latest transactions

        [Parameter(Mandatory = $false)]
        [string]$Fields  # Optional parameter to specify fields
    )

    # Load System.Web if needed for URL encoding
    if (-not ("System.Web" -as [type])) {
        Add-Type -AssemblyName System.Web
    }

    # API setup
    $endpoint = 'https://api.kaspa.org'
    $addressesPath = 'addresses'
    $fullTransactionsPageEndpoint = 'full-transactions-page'

    # Encode the Kaspa address
    $prefix = 'kaspa:'
    $encodedAddress = $prefix + [System.Web.HttpUtility]::UrlEncode($Address.Substring($prefix.Length))

    # Initialize collections for transactions and unique addresses
    $explorerResults = @{}

    # Set initial block time for pagination
    [Int64]$cachedBlockTime = $Before

    # Paginated loop to retrieve transactions
    do {
        Write-Verbose "Current Cached Block Time: $cachedBlockTime"

        # Build the request URL with updated block time and optional fields
        $requestUrl = "$endpoint/$addressesPath/$encodedAddress/$fullTransactionsPageEndpoint`?limit=$Limit&before=$cachedBlockTime&resolve_previous_outpoints=no"
        if ($Fields) { $requestUrl += "&fields=$Fields" }

        Write-Verbose "Requesting data from URL: $requestUrl"

        # API request to get transactions
        try {
            $response = Invoke-RestMethod -Uri $requestUrl -Method Get -Headers @{ 'accept' = 'application/json' }
            Write-Verbose "Retrieved JSON response: $(ConvertTo-Json -InputObject $response -Depth 10)"
        } catch {
            Write-Output "Failed to retrieve transactions. Please check the Kaspa address or endpoint."
            break
        }

        # Exit if no transactions were returned
        if ($null -eq $response -or $response.Count -eq 0) {
            Write-Verbose "No transactions retrieved. Ending pagination."
            break
        }

        # Add current page of transactions to the collection
        $explorerResults["Transactions"] += $response
        Write-Verbose "Retrieved $($response.Count) transactions. Total transactions so far: $($explorerResults.Transactions.Count)"

        # Update cachedBlockTime with the last block time in the response
        $cachedBlockTime = ($response | Select-Object -Last 1).block_time
        Write-Verbose "Updated Cached Block Time: $cachedBlockTime"

    } while ($response.Count -gt 0)

    # Gather unique addresses using hashset.
    if (($OutputType -eq "UniqueAddresses") -or ($OutputType -eq "All")){
        # Initialize a HashSet to store unique addresses as strings
        $uniqueAddresses = [System.Collections.Generic.HashSet[string]]::new()

        try {
            # If output selection is UniqueAddresses, collect addresseses and process.
            foreach ($transaction in $explorerResults.transactions) {
                foreach ($output in $transaction.outputs) {
                    # Add each address to the HashSet; suppress True/False output with [void]
                    [void]$uniqueAddresses.Add($output.script_public_key_address)
                }
            }

            $explorerResults.add("UniqueAddresses", $uniqueAddresses)
        }
        catch {
            Write-Error "An error occurred: $($_.Exception.Message)"
        }
        finally {
            $uniqueAddresses = $null
        }
    }

    # Remove duplicates from unique addresses if UniqueAddresses is enabled
    switch ($OutputType) {
        "Transactions" {
            return $explorerResults.Transactions
        }
        "UniqueAddresses" {
            return $explorerResults.UniqueAddresses
        }
        "All" {
            return $explorerResults
        }
        Default { "Selection is not recognized."}
    }
}
