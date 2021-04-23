<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    Detects if the Office Click-to-Run service is running. This is based on the Microsoft script but includes corrections.
.NOTES
    FileName:   Restart_Stopped_Office_C2R_Service_Remediate.ps1
    Date:       01/03/2021
    Author:     Mark Kerry
#>

# Define Variables
$svcCur = "ClickToRunSvc"
$curSvcStat,$svcCTRSvc,$errMsg = "","",""
$ctr = 0

# First, let's make sure nothing has changed since detection and service exists and is stopped
try {        
    $svcCTRSvc = Get-Service $svcCur
    $curSvcStat = $svcCTRSvc.Status
}
catch {    
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}

# If the service got started between detection and now (nested if) then return
# If the service got uninstalled or corrupted between detection and now (else) then return the "Error: " + the error
If ($curSvcStat -ne "Stopped") {
    if ($curSvcStat -eq "Running") {
        Write-Output "Running"
        exit 0
    }
    else {
        Write-Error $errMsg
        exit 1
    }
}

# Okay, the service should be there and be stopped, we'll change the startup type and get it running
try {        
    Set-Service $svcCur -StartupType Automatic
    Start-Service $svcCur
    while ((Get-Service $svcCur).Status -ne "Running") {
        Start-Sleep -Seconds 5
        $ctr++
        if ($ctr -eq 12) {
            Write-Output "Office C2R service could not be started after 60 seconds"
            exit 1
        }
    }
}
catch {    
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}