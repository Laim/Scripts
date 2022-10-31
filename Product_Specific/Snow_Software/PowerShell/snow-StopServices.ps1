try {
    Get-Service snow* | Stop-Service -Force 
} catch {
    Write-Host "Error, are you running as Administrator?"
}