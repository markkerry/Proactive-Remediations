<#
.SYNOPSIS
    Remediation script for a MEM Proactive Remediation.
.DESCRIPTION
    NoAutoUpdate registry DWORD should not be set to 1.
    0 or not exist is compliant.
.NOTES
    FileName:   Enable_Automatic_Windows_Update_Remediate.ps1
    Date:       24/02/2021
    Author:     Mark Kerry
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$regName = "NoAutoUpdate"
$regType = "DWORD"
$regValue = 0

try {
    Set-ItemProperty -Path $regPath -Name $regName -Type $regType -Value $regValue -Force -ErrorAction Stop
}
catch {
    Write-Output "Failed to change the $regName to $regValue"
}