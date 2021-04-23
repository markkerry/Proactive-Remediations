<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    NoAutoUpdate registry DWORD should not be set to 1 
    0 or not exist is compliant.
.NOTES
    FileName:   Enable_Automatic_Windows_Update_Detection.ps1
    Date:       24/02/2021
    Author:     Mark Kerry
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$regName = "NoAutoUpdate"
$regValue = 0

try {
    $registry = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop | Select-Object -ExpandProperty $regName
    if ($registry -eq $regValue){
        Write-Output "Compliant"
        exit 0
    }
    else { 
        Write-Warning "Not Compliant"
        exit 1
    }
} 
catch {
    Write-Output "Compliant. $regName does not exist"
    exit 0
}