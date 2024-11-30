function Show-KasMenu {
    <#
    .SYNOPSIS
    Displays the configuration menu.

    .DESCRIPTION
    This function shows the configuration menu to the user.
    #>
    Write-Host "`n     Configuration Menu     " -ForegroundColor Cyan
    Write-Host "1. View Current API Versions"
    Write-Host "2. Set KasplexAPI Version"
    Write-Host "3. Set KaspaExplorerAPI Version"
    Write-Host "`n0. Confirm Changes and Save" -ForegroundColor Green
    Write-Host "Q. Quit." -ForegroundColor Red
    Write-Host "                               "
    Write-Host "Enter your choice:" -NoNewline
}
