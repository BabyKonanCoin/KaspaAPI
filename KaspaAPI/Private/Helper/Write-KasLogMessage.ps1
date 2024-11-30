function Write-KasLogMessage {
    [CmdletBinding()]
    param (
        [string]$Message,
        [switch]$ToFile,
        [string]$Path
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"

    # Write to Verbose output
    Write-Verbose $logEntry

    # Optionally log to file if the -ToFile switch is used
    if ($ToFile) {
        Add-Content -Path $Path -Value $logEntry
    }
}
