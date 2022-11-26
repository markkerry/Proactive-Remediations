<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    When the last time this proactive remediation was run.

    If greater than 5 days, check for store updates
.NOTES
    FileName:   Update_Store_Apps_Detection.ps1
    Date:       24/01/2022
    Author:     Mark Kerry
#>

# Ensure the log destination exists
if (!(Test-Path -Path "C:\Users\Public\Documents\IntuneDetectionLogs")) {
    New-Item -Path "C:\Users\Public\Documents" -Name "IntuneDetectionLogs" -ItemType Directory | Out-Null
}

function Write-LogEntry {
    param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$FileName = "StoreAppsUpdates.log"
    )
    # Determine log file location
    $LogFilePath = Join-Path -Path "C:\Users\Public\Documents" -ChildPath "IntuneDetectionLogs\$($FileName)"

    # Add value to log file
    try {
        Out-File -InputObject $Value -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning -Message "Unable to append log entry to StoreAppsUpdates.log"
        exit 1
    }
}

$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_EnterpriseModernAppManagement_AppManagement01"

try {
    $wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className -ErrorAction Stop
    $result = $wmiObj.UpdateScanMethod()

    if ($result.ReturnValue -eq 0) {
        Write-Output "Invoked Microsoft Store Apps Update Check"
    }
    else {
        Write-Output "The ReturnValue was $($result.ReturnValue)"
    }

    Write-LogEntry -Value "$(Get-Date -format g): Invoked Microsoft Store Apps Update Check"
}
catch {
    Write-Output "Failed to get WMI Object"
    exit 1
}