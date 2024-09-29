# Script to check PowerShell execution logs and command prompt usage
$desktopPath = [Environment]::GetFolderPath("Desktop")
$outputFile = Join-Path $desktopPath "ScriptExecutionLogs.txt"

# PowerShell Script Block Logs (Event ID 4104)
Add-Content -Path $outputFile -Value "`nPowerShell Script Block Logging:`n"
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational'; Id=4104} -MaxEvents 50 | Format-Table TimeCreated, Message -AutoSize | Out-File -Append $outputFile

# Recent Command Prompt Executions (Event ID 4688)
Add-Content -Path $outputFile -Value "`nRecent Command Prompt Executions:`n"
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4688} -MaxEvents 50 | Format-Table TimeCreated, Message -AutoSize | Out-File -Append $outputFile

Write-Host "Script execution logs saved to $outputFile"
