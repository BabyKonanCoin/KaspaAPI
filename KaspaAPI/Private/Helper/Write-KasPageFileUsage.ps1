function Write-KasPageFileUsage {
    [CmdletBinding()]
    param (
        [switch]$ToFile,
        [string]$Path
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $pageFile = Get-CimInstance -ClassName Win32_PageFileUsage

    foreach ($pf in $pageFile) {
        $totalPageFile = $pf.AllocatedBaseSize * 1MB # Total allocated page file size
        $currentUsage = $pf.CurrentUsage * 1MB       # Current page file usage
        $totalEntry = "$timestamp - Page File Total Size (bytes): $totalPageFile"
        $currentEntry = "$timestamp - Page File Current Usage (bytes): $currentUsage"

        # Write to Verbose output
        Write-Verbose $totalEntry
        Write-Verbose $currentEntry

        # Optionally log to file if the -ToFile switch is used
        if ($ToFile) {
            Add-Content -Path $Path -Value $totalEntry
            Add-Content -Path $Path -Value $currentEntry
        }
    }
}
