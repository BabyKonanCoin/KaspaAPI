function Invoke-KasJobResult {
    param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Job]$Job,

        [Parameter(Mandatory = $true)]
        [hashtable]$Results,

        [Parameter(Mandatory = $true)]
        [hashtable]$UniqueAddressDump
    )

    $jobResult = Receive-Job -Job $Job -Wait
    if ($jobResult) {
        foreach ($item in $jobResult.VerifiedTickHolders) {
            if (-not $Results.ContainsKey($item.Address)) {
                $Results[$item.Address] = $item
            }
        }
        foreach ($uniqueAddress in $jobResult.UniqueAddresses) {
            if (-not $UniqueAddressDump.ContainsKey($uniqueAddress)) {
                $UniqueAddressDump[$uniqueAddress] = $uniqueAddress
            }
        }
    }
    Remove-Job -Job $Job -ErrorAction SilentlyContinue
}
