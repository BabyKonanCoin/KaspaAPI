function Start-KasTest {
    <#
    .SYNOPSIS
    Processes Kaspa wallet addresses to retrieve KRC20 token information.

    .DESCRIPTION
    `Start-KasTest` retrieves KRC20 token balances and unique addresses from
    transactions for each wallet address. It supports concurrent jobs to
    process addresses in parallel and can output results to CSV or XML files.

    .PARAMETER Addresses
    Array of Kaspa wallet addresses to process.

    .PARAMETER Tick
    KRC20 token ticker to filter balance information.

    .PARAMETER ModulePath
    Path to PowerShell module for dependencies.

    .PARAMETER AppenedUniqueAddresses
    Append unique addresses to a CSV file.

    .PARAMETER AppendTickHolders
    Append verified holders to a CSV file.

    .PARAMETER DumpTxAddresses
    Dump unique addresses found in transactions to a file.

    .PARAMETER MaxJobs
    Maximum number of concurrent jobs (1–8). If 0 or 1, runs serially.

    .EXAMPLE
    $params = @{
        Addresses              = @("kaspa:address", "kaspa:another address")
        Tick                   = "DOGE"
        ModulePath             = "C:\Modules\KaspaAPI\KaspaAPI.psm1"
        AppenedUniqueAddresses = $true
        AppendTickHolders      = $true
        DumpTxAddresses        = $true
        MaxJobs                = 8
    }
    Start-KasTest @params

    .EXAMPLE
    $results = Start-KasTest -Addresses $addresses -Tick "konan"
    -AppenedUniqueAddresses -AppendTickHolders -DumpTxAddresses
    -Verbose -MaxJobs 8 -ModulePath

    .NOTES
    Requires Kaspa blockchain API and specified module dependencies.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Addresses,

        [Parameter(Mandatory = $true)]
        [string]$Tick,

        [Parameter(Mandatory = $true)]
        [string]$ModulePath,

        [Parameter()]
        [switch]$AppenedUniqueAddresses,

        [Parameter()]
        [switch]$AppendTickHolders,

        [Parameter()]
        [switch]$DumpTxAddresses,

        [Parameter()]
        [switch]$ReturnUniqueAddresses,

        [Parameter()]
        [ValidateRange(1, 20)]
        [int]$MaxJobs
    )

    begin {

        Get-KasMenu

        # Generate paths for output files based on specified parameters.
        if ($AppenedUniqueAddresses) {
            $AppenedUAPath = Get-KasDatedFileName -FileNamePrefix "UniqueAddress" `
                            -SubFolder "$($Tick)_UniqueAddresses" -Format CSV
            Write-Verbose "# Generated path for UniqueAddresses CSV: $AppenedUAPath"
        }

        if ($AppendTickHolders) {
            $AppendVHTRPath = Get-KasDatedFileName -FileNamePrefix "TickHolders" `
                            -SubFolder "$($Tick)_ValidHolders" -Format CSV
            Write-Verbose "# Generated path for VerifiedHolders CSV: $AppendVHTRPath"
        }

        if ($DumpTxAddresses) {
            $DumpTxAddy = Get-KasDatedFileName -FileNamePrefix "DumpTxAddresses" `
                        -SubFolder "$($Tick)_DumpTxAddresses" -Format CSV
            Write-Verbose "# Generated path for DumpTxAddresses XML: $DumpTxAddy"
        }

        $LogPath = Get-KasDatedFileName -FileNamePrefix "Logs" `
                -SubFolder "MemoryInformation" -Format CSV
        Write-Verbose "# Generated path for MemoryInformation: $LogPath"

        $results = @{}
        $UniqueAddressDump = @{}
        $jobs = @()  # Array to manage job objects
        $processedAddresses = @{}  # Track processed addresses
    }

    process {
        # Only process unique addresses in the provided array.
        #$uniqueAddresses = $Addresses | Sort-Object -Unique
        $totalAddresses = $addresses.Count
        $addressCount = 0  # Initialize count for progress tracking

        foreach ($address in $addresses) {
            $addressCount++

            # Check if address count is a multiple of 50
            if ($addressCount % 50 -eq 0) {
                Use-KasFileWriteMutex -Action {
                    Write-Verbose "Starting logging operations with mutex protection"

                    # Log custom message, memory usage, and page file usage
                    Write-KasLogMessage "Starting log operation at address count $addressCount..." -Path $LogPath -ToFile -Verbose
                    Write-KasMemoryUsage -Path $LogPath -ToFile -Verbose
                    Write-KasPageFileUsage -Path $LogPath -ToFile -Verbose

                    Write-Verbose "Logging operations completed with mutex protection"
                }
            }

            # Display progress bar
            Write-Progress -Activity "Processing Addresses" `
                           -Status "Processing address $addressCount of $totalAddresses" `
                           -PercentComplete (($addressCount / $totalAddresses) * 100)

            if ($processedAddresses.ContainsKey($address)) {
                Write-Verbose "Address $address has already been processed, skipping."
                continue
            }

            # Launch jobs only if under the MaxJobs limit.
            while ($jobs.Count -ge $MaxJobs) {
                Start-Sleep -Milliseconds 200

                # Check and handle completed jobs.
                $completedJobs = $jobs | Where-Object { $_.State -eq 'Completed' }
                foreach ($job in $completedJobs) {
                    Invoke-KasJobResult -Job $job -Results $results -UniqueAddressDump $UniqueAddressDump
                    $jobs = $jobs | Where-Object { $_.Id -ne $job.Id }
                }
            }

            # Start a new job for the current address.
            $job = Start-Job -ScriptBlock {
                param ($address, $tick, $uaPath, $vhPath, $modulePath)

                Import-Module -Name $modulePath -ErrorAction Stop

                $data = Start-KasBlockTxKrc20 -Address $address -Tick $tick -UniqueAddressPath $uaPath -VerifiedHoldersPath $vhPath -ReturnObject

<#
 # {                return [PSCustomObject]@{
                    VerifiedTickHolders = $data.VerifiedTickHolders
                    UniqueAddresses = $data.UniqueAddresses
                }:Enter a comment or description}
#>
            } -ArgumentList $address, $Tick, $AppenedUAPath, $AppendVHTRPath, $ModulePath

            $jobs += $job
            $processedAddresses[$address] = $true  # Mark address as processed
        }

<#
 # {        # Finalize any remaining jobs after the loop
        foreach ($job in $jobs) {
            Invoke-KasJobResult -Job $job -Results $results -UniqueAddressDump $UniqueAddressDump
        }
:Enter a comment or description}
#>
        # Export unique addresses and verified holders if specified.
        if ($DumpTxAddresses -and $UniqueAddressDump.Count -gt 0) {
            Write-Verbose "Exporting unique addresses to $DumpTxAddy"
            Use-KasFileWriteMutex -Action {
                Get-KasDataDump -Data $UniqueAddressDump.Values -Path $DumpTxAddy
            }
        }

        if ($ReturnUniqueAddresses) {
            Write-Verbose "Returning results hashtable with $($results.Count) unique entries."
            return $results
        }

    }
}
