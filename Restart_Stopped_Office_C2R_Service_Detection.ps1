<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    Detects if the Office Click-to-Run service is running. This is based on the Microsoft script but includes corrections.
.NOTES
    FileName:   Restart_Stopped_Office_C2R_Service_Detection.ps1
    Date:       01/03/2021
    Author:     Mark Kerry
#>

# Define Variables
$curSvcStat,$svcCTRSvc,$errMsg = "","",""

# Main script
if (-not (Test-Path -Path 'hklm:\Software\Microsoft\Office\16.0')) {
    Write-Host "Office 16.0 (or greater) not present on this machine"
    exit 0
}

try {        
    $svcCTRSvc = Get-Service "ClickToRunSvc"
    $curSvcStat = $svcCTRSvc.Status
}
catch {    
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}

if ($curSvcStat -eq "Running") {
    Write-Output $curSvcStat
    exit 0                        
}
else {
    if ($curSvcStat -eq "Stopped") {
        Write-Output $curSvcStat
        exit 1     
    }
    else {
        Write-Error "Error: " + $errMsg
        exit 1
    }
}