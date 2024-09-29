# DFIR-Triaging
Contains 3 powershells to assist in identifying initial attack vector

Here is a description suitable for a GitHub repository based on the three PowerShell scripts provided:


---

Endpoint Investigation PowerShell Scripts

This repository contains PowerShell scripts designed to assist in the investigation of suspicious activities on Windows endpoints. These scripts are intended to collect evidence related to initial infection vectors, persistence mechanisms, and suspicious file executions. They are particularly useful in cybersecurity incident response scenarios, where gathering detailed information about system behavior is crucial.

Scripts Overview

1. Browser and Email Client History Extraction Script

File: ExtractHistory.ps1

Purpose: This script extracts browser history from Google Chrome and analyzes recent downloads from the user's system. Additionally, if Microsoft Outlook is installed, it scans the last 20 emails for URLs embedded in the email body. The extracted data is saved to a text file on the user's desktop.

Features:

Extracts Google Chrome browser history using sqlite3.exe placed on the desktop.

Lists recent downloads from the Downloads folder.

Extracts URLs from recent Outlook emails (if Outlook is installed).


Prerequisites:

sqlite3.exe must be placed on the user's desktop for Chrome history extraction.

Outlook must be installed for email URL extraction.



2. Autostart, Scheduled Tasks, and Registry Monitoring Script

File: AutostartAndRegistryCheck.ps1

Purpose: This script checks common persistence mechanisms such as autostart locations in the Windows Registry, the startup folder, and scheduled tasks. It also checks for recent changes in critical registry paths. The results are saved to a text file on the desktop.

Features:

Scans autostart entries in the Windows Registry and Startup folder.

Enumerates all scheduled tasks on the system.

Checks for recent registry modifications to track possible persistence techniques.


Prerequisites:

Requires administrative privileges to access system-level data.



3. PowerShell and Command Execution Logs Script

File: ScriptExecutionLogs.ps1

Purpose: This script extracts logs of PowerShell script block executions and recent command prompt activity (Event IDs 4104 and 4688). The data provides insight into any suspicious or unauthorized script executions on the system. The results are saved to a text file on the desktop.

Features:

Captures PowerShell script execution logs from Event Viewer.

Tracks recent command prompt activity.

Useful for detecting script-based attacks or malware leveraging PowerShell.

4.Recent File Executions and Prefetch Analysis Script

File: RecentExecutions.ps1

Purpose: Tracks recently executed files and examines Prefetch data for evidence of malware or suspicious file executions. Results are saved to a text file on the desktop.

Features:

Lists recently accessed files in common attack locations like %TEMP%.

Extracts Prefetch data to check for recently executed programs.

Prerequisites:

Ensure PowerShell logging (script block logging) is enabled on the system.

Requires administrative privileges to access event logs.



Installation and Usage

1. Download the Repository:

Clone or download the repository to your local system.



2. Place sqlite3.exe on Desktop (Required for Chrome History Script):

Download sqlite3.exe from the official SQLite website.

Place sqlite3.exe on the desktop, as the Chrome history extraction script relies on this utility to query the browser's SQLite database.



3. Run the Scripts:

Open PowerShell as an administrator.

Run each script based on the investigation requirements:

.\ExtractHistory.ps1

.\AutostartAndRegistryCheck.ps1

.\ScriptExecutionLogs.ps1




4. Review Output:

Each script will create a .txt file on the desktop containing the relevant output (e.g., HistoryCheck.txt, AutostartAndRegistryCheck.txt, ScriptExecutionLogs.txt).




Prerequisites

PowerShell Version: Ensure PowerShell 5.0 or higher is installed.

Administrative Privileges: Some scripts require elevated privileges to access system directories, registry, and event logs.

PowerShell Execution Policy: Set the execution policy to RemoteSigned if required:

Set-ExecutionPolicy RemoteSigned -Scope Process

Enable PowerShell Logging: For PowerShell script block logging, ensure it is enabled using:

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "ScriptBlockLogging" -Value 1 -PropertyType DWORD


Contributions

Contributions to improve these scripts or add additional forensic or incident response capabilities are welcome. Please submit a pull request or open an issue for discussion.


---




