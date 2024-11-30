function Start-KasBlockTxKrc20 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Address,

        [Parameter(Mandatory = $true)]
        [string]$Tick,

        [Parameter(Mandatory = $false)]
        [Int64]$Before,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1,8)]
        [int]$MaxJobs = 8,

        [Parameter(Mandatory = $false)]
        [string]$UniqueAddressPath,

        [Parameter(Mandatory = $false)]
        [string]$VerifiedHoldersPath,

        [Parameter(Mandatory = $false)]
        [switch]$ReturnObject
    )

    # Get Kaspa transactions with unique addresses
    $kasTxResults = Get-KasTx -Address $Address -Limit 50 -Before $Before -OutputType UniqueAddresses
    Write-Verbose "Unique addresses retrieved: $($kasTxResults)"

    # Ensure unique addresses have data before attempting to write
    if ($UniqueAddressPath -and $kasTxResults -gt 0) {
        Use-KasFileWriteMutex -Action {
            Write-Verbose "Writing unique addresses to $UniqueAddressPath"
            foreach ($address in $kasTxResults) {
                [PSCustomObject]@{ Address = $address } | Export-Csv -Path $UniqueAddressPath -Append -NoTypeInformation
                #$address | Export-Csv -Path $UniqueAddressPath -Append -NoTypeInformation
            }
            Write-Verbose "Unique addresses appended to $UniqueAddressPath"
        }
    } else {
        Write-Verbose "No unique addresses to write or path not provided."
    }


    try {
        # Start balance check jobs
        $krc20holders = Start-KasKrc20BalanceJobs -Tick $Tick -Addresses $kasTxResults -MaxJobs $MaxJobs

        # Initialize a list to store keys for removal
        $keysToRemove = @()

        # Filter verified tick holders with non-zero balances for the specified ticker
        foreach ($address in $krc20holders.Keys) {
            $krc20wallet = $krc20holders[$address]

            if ($null -eq $krc20wallet -or $null -eq $krc20wallet.Balance) {
                Write-Verbose "Skipping address $address due to missing KasplexData or result"
                $keysToRemove += $address  # Add to removal list
                continue
            }

            if ($krc20wallet.Balance -le 0) {
                $keysToRemove += $address  # Add to removal list
            }
        }

        # Now remove keys after enumeration is complete
        foreach ($key in $keysToRemove) {
            $krc20holders.Remove($key)
        }

        Write-Verbose "Verified tick holders retrieved: $($krc20holders.Count)"

        # Write verified tick holders to file with mutex protection
        if ($VerifiedHoldersPath -and $krc20holders.Count -gt 0) {
            Use-KasFileWriteMutex -Action {
                Write-Verbose "Writing verified tick holders to $VerifiedHoldersPath"
                $krc20holders.Values | Export-Csv -Path $VerifiedHoldersPath -Append -NoTypeInformation
                Write-Verbose "Verified tick holders appended to $VerifiedHoldersPath"
            }
        } else {
            Write-Verbose "No verified tick holders to write or path not provided."
        }
    } catch {
        Write-Error "Error appending krc20 holders to file: $_"
    }

    # Return both verified tick holders and unique addresses for further processing
    if ($ReturnObject){
        return [PSCustomObject]@{
            VerifiedTickHolders = $krc20holders
            UniqueAddresses = $kasTxResults
        }
    }
}
