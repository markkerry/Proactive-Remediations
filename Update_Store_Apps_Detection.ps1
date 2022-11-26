<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    The Proactive Remediation will be set to check every 7 days.
    The remediation will output to a log file. So this detection on the 
    7th day will get the date of 5 days ago and if the log was modified
    at an earlier date will return non-compliant. That way this PR
    will always run weekly on machines.
.NOTES
    FileName:   Update_Store_Apps_Detection.ps1
    Date:       24/01/2022
    Author:     Mark Kerry
#>

$logPath = "C:\Users\Public\Documents\IntuneDetectionLogs\StoreAppsUpdates.log"

if (Test-Path -Path $logPath) {
    $logAge = (Get-ChildItem -Path $logPath).LastWriteTime
    $fiveDaysAgo = (Get-Date).AddDays(-5)
    if ($logAge -lt $fiveDaysAgo) {
        Write-Output "Non-Compliant. Ran over 5 days ago"
        exit 1
    }
    else {
        Write-Output "Compliant. Ran less than 5 days ago"
        exit 0
    }
}
else {
    Write-Output "Non-Compliant. StoreAppsUpdates.log does not exist"
    exit 1
}