<#
.SYNOPSIS
    Remediation script for a MEM Proactive Remediation.
.DESCRIPTION
    NoAutoUpdate registry DWORD should not be set to 1 
    0 or not exist is compliant.
.NOTES
    FileName:   Enable_Automatic_Windows_Update_Remediate.ps1
    Date:       24/02/2021
    Author:     Mark Kerry
#>

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$Name = "NoAutoUpdate"
$Type = "DWORD"
$Value = 0

try {
    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value -Force -ErrorAction Stop
}
catch {
    Write-Output "Failed to change the $Name to $Value"
}