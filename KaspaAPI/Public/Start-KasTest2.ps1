function Start-KasTest2 {
    # OLD Version...
    #
    # Main cmdlet for iterating a batch of addresses.
    # Store unique addresses gathered to allow for nested
    # analysis of activty off of source addreses. Loop
    # $filePath parameter to contiue a search from every
    # tree in the forest...
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Addresses
    )

    # Generate a dated filename in the UniqueAddresses subfolder to pass for
    # unique addresses from each paginated request. These addresses are
    # filtered before being appended to the .csv for each new run of
    # the Start-KasTest cmdlet.
    $filePath = Get-KasDatedFileName -FileNamePrefix "UniqueAddress"

    # Store results from each interation of provided addresses.
    $results = @()

    foreach ($address in $Addresses) {
        $results += Start-KasBlockTxKrc20 -Address $address -Tick "insert tick here" -MaxJobs 8 -Path $filePath -Verbose
    }

    # Return all addresses gathered from every transactions to xml
    $script:DataDump | Sort-Object -Unique | Get-KasDataDump -Verbose

    return $results
}
