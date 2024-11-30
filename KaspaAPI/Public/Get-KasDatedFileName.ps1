function Get-KasDatedFileName {
    [CmdletBinding()]
    param(
        [string]$FileNamePrefix = "KasDataDump",  # Default prefix for the file name
        [string]$SubFolder = "UniqueAddresses",   # Default subfolder name
        [ValidateSet("CSV", "XML")]
        [string]$Format = "CSV"                   # Output format: CSV or XML
    )

    # Get base path for KaspaAPI data
    $basePath = Get-KasAppDataPath

    if (-not (Test-Path -Path $basePath)){
        New-KasAppDataPath
    } else {
        $basePath = Get-KasAppDataPath
    }

    # Combine base path with the specified subfolder
    $subFolderPath = Join-Path -Path $basePath -ChildPath $SubFolder

    # Ensure the subfolder exists
    if (-not (Test-Path -Path $subFolderPath)) {
        New-Item -ItemType Directory -Path $subFolderPath -Force | Out-Null
    }

    # Generate a timestamped filename with the appropriate extension based on format
    $date = Get-Date -Format "yyyyMMdd_HHmmssfff"
    $extension = if ($Format -eq "XML") { "xml" } else { "csv" }
    $fileName = "${FileNamePrefix}_$date.$extension"

    # Combine the subfolder path with the timestamped filename
    return Join-Path -Path $subFolderPath -ChildPath $fileName
}
