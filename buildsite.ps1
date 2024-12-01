mkdocs build

# Define paths
$DocsFolder = ".\docs\en-US"         # Path to the en-US folder
$MkDocsFile = ".\mkdocs.yml"         # Path to the mkdocs.yml file

# Read existing mkdocs.yml content
$MkDocsContent = Get-Content -Path $MkDocsFile -Raw  # Use -Raw to get the full content as a single string

# Initialize the Commands section
$CommandsNav = @()  # Start as an empty array
$MarkdownFiles = Get-ChildItem -Path $DocsFolder -Filter *.md | Sort-Object Name

foreach ($File in $MarkdownFiles) {
    # Extract the title from the first line starting with "# "
    $Title = Select-String -Path $File.FullName -Pattern "^# " | ForEach-Object { ($_ -split "\s", 2)[1] }

    # If no title is found, fall back to the base name of the file
    if (-not $Title) {
        $Title = $File.BaseName
    }

    # Add the file to the navigation
    $FilePath = "en-US/$($File.Name)"  # Relative path to the file
    $CommandsNav += "      - $Title`: $FilePath"  # Add to Commands nav
}

# Combine the CommandsNav array into a single string for insertion
$CommandsNavString = $CommandsNav -join "`n"

# Check if the Commands section exists
if ($MkDocsContent -match "  - Commands:") {
    # Remove existing sub-commands under "  - Commands:"
    $MkDocsContent = $MkDocsContent -replace "(  - Commands:\s*(?:\s{6}- .+\n)+)", "  - Commands:`n"

    # Re-add the sub-commands under "  - Commands:"
    $MkDocsContent = $MkDocsContent -replace "(  - Commands:`n)", "  - Commands:`n$CommandsNavString`n"
} else {
    Write-Host "Commands section not found. No changes were made." -ForegroundColor Yellow
}

# Save the updated mkdocs.yml
$MkDocsContent | Set-Content -Path $MkDocsFile -Encoding UTF8

Write-Host "Commands section updated in mkdocs.yml!"
