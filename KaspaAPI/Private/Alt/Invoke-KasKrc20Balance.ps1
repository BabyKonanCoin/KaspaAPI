function Invoke-KasKrc20Balance {
    # Single thread query.
    [CmdletBinding()]
    param(
        #[Parameter(ValueFromPipeline=$true)]
        $transcactions,
        $tick
    )
<#
 # {    # Define the base API URL without a trailing slash
    $api = 'https://api.kaspa.org/addresses'
    $address = ''
    $method = 'full-transactions-page'
    $parameters = '?limit=500&before=1730255706424&resolve_previous_outpoints=no'
    # Construct the URI
    $uri = "$api/$address/$method/$parameters"

    # ToDo: need to add search for full transactions first to get transaction id
    # for the epoch-millis of the block for the latest transaction.
    # This will allow for searching from latest tx to be able to do a full page
    # search.
    # /addresses/{kaspaAddress}/full-transactions
    # https://api.kaspa.org/docs#/Kaspa addresses/get_full_transactions_for_address_addresses__kaspaAddress__full_transactions_get

    # ToDo: Added paginated fullpage search by using last epoch-millis from the
    # last block until completed.

    # Use the constructed URI with Invoke-RestMethod
    $fullTransactionsPage = Invoke-RestMethod -Uri $uri

    # Output the result for confirmation
    #$fullTransactionsPage


    #region pulladdresses:Enter a comment or description}
#>

    # Initialize the list of addresses and token ticker
    #$publicAddresses = $fullTransactionsPage.outputs.script_public_key_address
    $publicAddresses = ($transcactions.outputs.script_public_key_address) | Sort-Object -Unique

    Write-Verbose "Addresses to process: $publicAddresses"

    # Initialize an array to hold PSCustomObject for each address and API response
    $validHolders = @()



    # Process each address
    foreach ($address in $publicAddresses) {
        # Debug: Show each address as it's processed
        Write-Verbose "Processing address: $address"

        # Construct the Kasplex API URL
        $kasplexApiUri = "https://api.kasplex.org/v1/krc20/address/$address/token/$tick"

        try {
            # Get the API response for the address
            Write-Verbose "Fetching data for address: $address"
            $kasplexData = Invoke-RestMethod -Uri $kasplexApiUri

            # Create a PSCustomObject with the address and API data
            $holderObject = [PSCustomObject]@{
                Address = $address
                KasplexData = $kasplexData
            }

            $holderObject.kasplexData.result | Add-Member -MemberType NoteProperty -Name Address -Value $address

            # Add the custom object to the valid holders array
            $validHolders += $holderObject

            Write-Verbose "Retrieved $($holderObject.kasplexData.result.Count) address requests. Total so far: $($validHolders.Count)"
        } catch {
            Write-Warning "Failed to fetch data for address: $address. Error: $_"
        }
    }

    # Output the valid holders array with unique addresses
    return $validHolders


    # get addressed with blance that is a non-zero value.
    #  $validHolders.kasplexdata.result | where-object -FilterScript {(-not($_.balance -like "0"))}



    #endregion
}
