# Script to check autostart locations, scheduled tasks, and recent registry changes
$desktopPath = [Environment]::GetFolderPath("Desktop")
$outputFile = Join-Path $desktopPath "AutostartAndRegistryCheck.txt"

# Check Startup Folder
Add-Content -Path $outputFile -Value "`nStartup Folder Entries:`n"
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
Get-ChildItem -Path $startupFolder | ForEach-Object { $_.FullName } | Out-File -Append $outputFile

# Check Registry Autostart Locations
$autostartKeys = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
)
Add-Content -Path $outputFile -Value "`nRegistry Autostart Entries:`n"
foreach ($key in $autostartKeys) {
    Get-ItemProperty -Path $key -ErrorAction SilentlyContinue | ForEach-Object {
        $_.PSObject.Properties | Where-Object { $_.Name -ne "PSPath" } | Format-Table -AutoSize | Out-File -Append $outputFile
    }
}

# Check Scheduled Tasks
Add-Content -Path $outputFile -Value "`nScheduled Tasks:`n"
Get-ScheduledTask | Where-Object {$_.TaskPath -like "\*"} | Select-Object TaskName, TaskPath, State, Actions | Format-Table -AutoSize | Out-File -Append $outputFile

# Recent Registry Changes
Add-Content -Path $outputFile -Value "`nRecent Registry Changes:`n"
$recentRegChanges = Get-ChildItem -Path HKLM:\Software -Recurse | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 20
$recentRegChanges | Format-Table PSPath, LastWriteTime | Out-File -Append $outputFile

Write-Host "Autostart, scheduled tasks, and registry changes saved to $outputFile"
