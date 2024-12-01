function Start-KasKrc20BalanceJobs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Addresses,

        [Parameter(Mandatory = $true)]
        [string]$Tick,

        [Parameter(Mandatory = $false)]
        [int]$MaxJobs = 8
    )

    Write-Verbose "Total unique addresses to process: $($addresses.Count)"
    Write-Verbose "Maximum concurrent jobs: $MaxJobs"

    # Result collection (hashtable to store address-specific objects)
    $validHolders = @{}
    $jobs = New-Object System.Collections.Generic.List[System.Management.Automation.Job]

    foreach ($address in $addresses) {
        # Manage concurrent job count
        while ($jobs.Count -ge $MaxJobs) {
            Write-Verbose "Checking completed jobs. Active jobs: $($jobs.Count)"

            # Collect results from completed jobs
            $completedJobs = $jobs | Where-Object { $_.State -eq 'Completed' }
            foreach ($job in $completedJobs) {
                $jobResult = Receive-Job -Job $job
                if ($null -ne $jobResult) {
                    Write-Verbose "Received job result for address: $($jobResult.Address)"
                    $validHolders[$jobResult.Address] = $jobResult.Data
                }
                # Clean up
                Remove-Job -Job $job
                [void]$jobs.Remove($job)
            }
        }

        # Start a new job to fetch data
        $job = Start-Job -ScriptBlock {
            param ($address, $tick)
            Write-Verbose "Starting job for address: $address"
            $kasplexApiUri = "$script:KasplexAPI/v1/krc20/address/$address/token/$tick"

            try {
                $kasplexData = Invoke-RestMethod -Uri $kasplexApiUri
                # Define the output structure as a PSCustomObject with properties
                $balance = ($kasplexData.result.balance / [math]::Pow(10, $kasplexData.result.dec)).ToString("N" + $kasplexData.result.dec)
                $resultObject = [PSCustomObject]@{
                    Address     = $address
                    Data        = [PSCustomObject]@{
                        Address     = $address
                        Tick        = $kasplexData.result.tick
                        Balance     = $balance
                        Locked      = $kasplexData.result.locked
                        Dec         = $kasplexData.result.dec
                        OpScoreMod  = $kasplexData.result.opscoremod
                        Message     = $kasplexData.result.message
                    }
                }

                Write-Verbose "Successfully fetched data for address: $address"
                $balance = $null
                $kasplexData = $null
                return $resultObject
            } catch {
                Write-Warning "Failed to fetch data for address: $address. Error: $_"
                return $null
            }
        } -ArgumentList $address, $tick

        $jobs.Add($job)
    }

    # Finalize remaining jobs
    Write-Verbose "Waiting for remaining jobs to complete..."
    foreach ($job in $jobs) {
        $jobResult = Receive-Job -Job $job -Wait
        if ($null -ne $jobResult) {
            Write-Verbose "Received final job result for address: $($jobResult.Address)"
            $validHolders[$jobResult.Address] = $jobResult.Data
        }
        Remove-Job -Job $job
    }

    Write-Verbose "Total valid holders processed: $($validHolders.Count)"
    return $validHolders
}
