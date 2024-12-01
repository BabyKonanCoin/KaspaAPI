function Get-KasTxLatestBlockTime {
    # Get last block time from provided address
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Address,

        [Parameter(Mandatory = $false)]
        [string]$Fields  # Optional parameter to specify fields
    )

    # Check if System.Web is available, and load it if necessary
    if (-not ("System.Web" -as [type])) {
        Add-Type -AssemblyName System.Web
    }

    # Define the root endpoint of the API
    $endpoint = $script:KaspaExlorerAPI
    $addressesPath = 'addresses'
    $fullTransaction = 'full-transactions'

    # Only encode the part of the Kaspa address after the "kaspa:" prefix
    $prefix = 'kaspa:'
    $encodedKaspaAddress = $prefix + [System.Web.HttpUtility]::UrlEncode($Address.Substring($prefix.Length))

    $Limit = 1
    # Update the request URL with the latest `before` value
    $requestUrl = "$endpoint/$addressesPath/$encodedKaspaAddress/$fullTransaction`?limit=$Limit&offset=0&resolve_previous_outpoints=no"

    # Add 'fields' parameter if specified
    if ($Fields) {
        $requestUrl += "&fields=$Fields"
    }

    Write-Verbose "Requesting paginated data from URL: $requestUrl"

    # Make the GET request for the current page of transactions
    try {
        $response = Invoke-RestMethod -Uri $requestUrl -Method Get -Headers @{ 'accept' = 'application/json' }
        Write-Verbose "Retrieved JSON response: $(ConvertTo-Json -InputObject $response -Depth 10)"
    } catch {
        Write-Output "Failed to retrieve transactions. Please check the Kaspa address or endpoint."
        break
    }

    # Check if any transactions were returned
    if ($null -eq $response -or $response.Count -eq 0) {
        Write-Verbose "No transactions retrieved in the current request. Ending pagination."
        break
    }

    # Return all collected paginated transactions
    return $response.block_time
}
