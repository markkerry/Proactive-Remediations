<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    Checks the registry for when the machine last checked to update office. 
    If more than 3 days ago mark non-compliant.
.NOTES
    FileName:   Update_Office_C2R_Detection.ps1
    Date:       22/04/2021
    Author:     Mark Kerry
#>

# First check Office Pro Plus is installed
if (-not (Test-Path -Path 'hklm:\Software\Microsoft\Office\ClickToRun')) {
    Write-Output "Office C2R is not present on this machine"
    exit 0
}

# Get the UpdateDetectionLastRunTime from the registry
$getRegValue = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Updates -Name UpdateDetectionLastRunTime).UpdateDetectionLastRunTime

# If RegKey not found exit as will need re-installing
if ($null -eq $getRegValue) {
    Write-Output "UpdateDetectionLastRunTime key not found. Re-install Office"
    exit 0
}

# If the UpdateDetectionLastRunTime LDAP time is 14 characters, add 0000 to the end
if ($getRegValue.Length -eq 14) {

    $ldapTime = $getRegValue + "0000"
    $lastUpdateTime = (Get-Date 1/1/1601).AddDays($ldapTime/864000000000)
    $threeDaysAgoTime = (Get-Date).AddDays(-3)
    
    # UpdateDetectionLastRunTime longer ago than 3 days, mark non-compliant
    if ($lastUpdateTime -lt $threeDaysAgoTime) {
        Write-Output "Non-Compliant. C2R update last ran greater than 3 days ago"
        exit 1
    } # Within 2 days mark compliant
    else {
        Write-Output "Compliant. C2R update last ran within 3 days ago"
        exit 0
    }
} # If UpdateDetectionLastRunTime value is empty the reg key for some reason is clear
elseif ($getRegValue.Length -eq 0) {
    Write-Output "Non-Compliant. Reg key value is empty"
    exit 1
} # Unable to detemrine the value of the UpdateDetectionLastRunTime reg key
else {
    Write-Output "Unable to determine length of reg key"
    exit 0
}