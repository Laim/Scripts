##
## AUTHOR: Laim McKenzie
## Version: 1.0
## Date: 26-01-2025
## Purpose: Copies contents of downloads directory to a chosen directory on the C drive to archive old downloads, that may be required later.
##

$sourceDirectory = "C:\Users\laim.mckenzie\Downloads"
$targetDirectory = "C:\_OLD_Downloads"  # Parent archive folder
$dateFormat = Get-Date -Format "yyyy-MM-dd"

# Create today's folder inside the target directory
$targetDirectoryToday = Join-Path $targetDirectory $dateFormat
New-Item -ItemType Directory -Path $targetDirectoryToday -Force | Out-Null

# Get all files & folders in Downloads (excluding target)
$items = Get-ChildItem -Path $sourceDirectory -Recurse -Force | Where-Object {
    $_.FullName -notlike "$targetDirectory*"
}

foreach ($item in $items) {

    # Determine relative path under Downloads
    $relativePath = $item.FullName.Substring($sourceDirectory.Length).TrimStart("\\")

    # Build full destination path
    $destinationPath = Join-Path $targetDirectoryToday $relativePath

    if ($item.PSIsContainer) {
        # Create folder structure
        New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
    }
    else {
        # Ensure target folder exists
        $destFolder = Split-Path $destinationPath -Parent
        New-Item -ItemType Directory -Path $destFolder -Force | Out-Null

        # Move file
        Move-Item -Path $item.FullName -Destination $destinationPath -Force
    }
}

#####
# This removes any left over empty sub directories
####

# Get directories deepest-first so we remove children before parents
$dirs = Get-ChildItem -Path $sourceDirectory -Directory -Recurse |
        Sort-Object FullName -Descending

foreach ($dir in $dirs) {
    # Delete only if empty
    if (-not (Get-ChildItem -Path $dir.FullName -Force)) {
        Remove-Item -Path $dir.FullName -Force
    }
}