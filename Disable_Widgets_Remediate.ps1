<#
.SYNOPSIS
    Remediation script for a MEM Proactive Remediation.
.DESCRIPTION
    Checks if Windows 11 device and if the News and Interests (Widgets)
    is disabled. No policy CSP for it yet
.NOTES
    FileName:   Disable_Widgets_Remediate.ps1
    Date:       25/11/2021
    Author:     Mark Kerry
#>

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh\"
$name = "AllowNewsAndInterests"
$type = "DWORD"
$value = 0

try {
    if (!(Test-Path -Path $path)) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\" -Name "Dsh" -Force | Out-Null -ErrorAction Stop
    }
    Set-ItemProperty -Path $path -Name $name -Type $type -Value $value -Force -ErrorAction Stop
}
catch {
    Write-Output "Failed to change the $name $type to $value"
}