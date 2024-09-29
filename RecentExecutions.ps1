# Script to check recent file executions and Prefetch data
$desktopPath = [Environment]::GetFolderPath("Desktop")
$outputFile = Join-Path $desktopPath "RecentExecutions.txt"

# Check recently executed files in %TEMP% and other suspicious directories
Add-Content -Path $outputFile -Value "`nRecently Executed Files:`n"
$foldersToCheck = @("$env:TEMP", "$env:USERPROFILE\AppData\Roaming", "$env:USERPROFILE\AppData\Local\Temp")
foreach ($folder in $foldersToCheck) {
    Get-ChildItem -Path $folder -Recurse -ErrorAction SilentlyContinue | Sort-Object LastAccessTime -Descending | Select-Object FullName, LastAccessTime | Out-File -Append $outputFile
}

# Check Prefetch Data
Add-Content -Path $outputFile -Value "`nPrefetch Files:`n"
$prefetchFolder = "C:\Windows\Prefetch"
Get-ChildItem -Path $prefetchFolder | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime | Out-File -Append $outputFile

Write-Host "Recent execution data saved to $outputFile"
