try {
    Get-Service snow* | Start-Service -PassThru
} catch {
    Write-Host "Error, are you running as Administrator?"
}