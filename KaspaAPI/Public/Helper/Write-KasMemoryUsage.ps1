function Write-KasMemoryUsage {
    [CmdletBinding()]
    param (
        [switch]$ToFile,
        [string]$Path
    )
    $memory = [System.GC]::GetTotalMemory($false)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - Memory Usage (bytes): $memory"

    # Write to Verbose output
    Write-Verbose $logEntry

    # Optionally log to file if the -ToFile switch is used
    if ($ToFile) {
        Add-Content -Path $Path -Value $logEntry
    }
}
