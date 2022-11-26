<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    Checks if Windows 11 device and if the News and Interests (Widgets)
    is disabled. No policy CSP for it yet
.NOTES
    FileName:   Disable_Widgets_Detection.ps1
    Date:       25/11/2021
    Author:     Mark Kerry
#>

# Get OS version
$osBuild = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild).CurrentBuild

if ($osBuild -like "22*") {
    # Windows 11. Get the registry Key
    try {
        $regItem = (Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' -Name AllowNewsAndInterests -ErrorAction Stop).AllowNewsAndInterests
        
        if ($regItem -eq "0") {
            Write-Output "AllowNewsAndInterests is $($regItem). Compliant"
            exit 0
        }
        else {
            Write-Output "AllowNewsAndInterests is $($regItem). Non-compliant"
            exit 1
        }
    }
    catch {
        Write-Output "AllowNewsAndInterests does not exist. Non-compliant"
        exit 1
    }

}
elseif ($osBuild -like "19*") {
    Write-Output "OS is Windows 10. Compliant"
    exit 0
}
else {
    Write-Output "Unknown OS"
    exit 0
}