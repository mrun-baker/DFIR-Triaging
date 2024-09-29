# Script to extract browser and email client history and save results to Desktop
$desktopPath = [Environment]::GetFolderPath("Desktop")
$outputFile = Join-Path $desktopPath "HistoryCheck.txt"
$sqlitePath = Join-Path $desktopPath "sqlite3.exe" # Reference to sqlite3.exe on the desktop

# Browser History - Chrome
Add-Content -Path $outputFile -Value "`nBrowser History:`n"

# Chrome History (ensure sqlite3.exe is on the desktop)
$chromeHistoryPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History"
if (Test-Path $chromeHistoryPath -and Test-Path $sqlitePath) {
    Add-Content -Path $outputFile -Value "`nGoogle Chrome History:`n"
    $query = "SELECT url, title, datetime(last_visit_time/1000000-11644473600,'unixepoch') as LastVisit FROM urls ORDER BY last_visit_time DESC LIMIT 50"
    & $sqlitePath $chromeHistoryPath $query | Out-File -Append $outputFile
} else {
    Add-Content -Path $outputFile -Value "Chrome history or sqlite3.exe not found."
}

# Check for recent downloads
Add-Content -Path $outputFile -Value "`nRecent Downloads:`n"
Get-ChildItem "$env:USERPROFILE\Downloads" | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime | Out-File -Append $outputFile

# Checking Outlook email links (if applicable)
try {
    Add-Content -Path $outputFile -Value "`nRecent Email Links:`n"
    $outlook = New-Object -ComObject Outlook.Application
    $namespace = $outlook.GetNamespace("MAPI")
    $inbox = $namespace.GetDefaultFolder(6) # 6 refers to the Inbox folder
    $messages = $inbox.Items | Sort-Object ReceivedTime -Descending | Select-Object -First 20
    foreach ($message in $messages) {
        if ($message.HTMLBody -match "href") {
            Add-Content -Path $outputFile -Value "From: $($message.SenderName), Subject: $($message.Subject)"
            [regex]::Matches($message.HTMLBody, 'href="(.*?)"') | ForEach-Object { $_.Groups[1].Value } | Out-File -Append $outputFile
        }
    }
} catch {
    Add-Content -Path $outputFile -Value "Unable to access Outlook emails or Outlook is not installed."
}

Write-Host "History and email analysis saved to $outputFile"
