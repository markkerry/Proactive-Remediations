<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    Clears the registry key of when it last checks then starts
    the scheduled task.
.NOTES
    FileName:   Update_Office_C2R_Remediation.ps1
    Date:       22/04/2021
    Author:     Mark Kerry
#>

# Clear the UpdateDetectionLastRunTime value
try {
    Clear-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Updates -Name UpdateDetectionLastRunTime -ErrorAction Stop
}
catch {
    Write-Output "Unable to clear UpdateDetectionLastRunTime value"
    exit 1
}

# Get the Schedluled task
$taskName = "Office Automatic Updates 2.0"
$getSchedTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

# If task found, check it's not running and start it.
# If not found exit as Office needs re-installing
if ($null -ne $getSchedTask) {
    if ($getSchedTask.State -ne "Running") {
        try {
            $getSchedTask | Start-ScheduledTask -ErrorAction Stop
        }
        catch {
            Write-Output "Failed to start the $taskName task"
            exit 1
        }
    }
} 
else {
    Write-Output "Scheduled task not found. Re-install Office C2R"
    exit 1
}

# Wait for the task to stop
$ctr = 0
while ((Get-ScheduledTask -TaskName $taskName).State -eq "Running") {
    Start-Sleep -Seconds 1
    $ctr++
    if ($ctr -eq 120) {
        Write-Output "$taskName still running after $ctr seconds"
        exit 1
    }
}

# Wait for reg key to be populated again
Start-Sleep 5
$getRegValue = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Updates -Name UpdateDetectionLastRunTime).UpdateDetectionLastRunTime
$getSchedTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

# Ensure device in the correct state
if (($getRegValue).length -ne 0 -and $getSchedTask.State -eq "Ready") {
    Write-Output "Process completed successfully"
    exit 0
}
else {
    Write-Output "Process may not have completed successfully"
    exit 0
}