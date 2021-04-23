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

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$Name = "NoAutoUpdate"
$Value = 0

try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    if ($Registry -eq $Value){
        Write-Output "Compliant"
        exit 0
    }
    else { 
        Write-Warning "Not Compliant"
        exit 1
    }
} 
catch {
    Write-Output "Compliant. $Name does not exist"
    exit 0
}