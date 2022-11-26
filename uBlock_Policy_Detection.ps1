<#
.SYNOPSIS
    Detection script for a MEM Proactive Remediation.
.DESCRIPTION
    Detects the trusted sites in uBlock extension of Chrome and Edge

    Update the $latestValue variable with any new domain so the detection can check if it exists
.NOTES
    FileName:   uBlock_Policy_Detection.ps1
    Date:       10/01/2022
    Author:     Mark Kerry
#>

$chromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy"
$edgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\3rdparty\Extensions\odfafepnkmbhccpbejgmiehpchacaeak\policy"
$name = "adminSettings"
$latestValue = "lightning.force.com"

try {
    $chromeReg = (Get-ItemProperty $chromePath -Name $name -ErrorAction Stop).$name
    $edgeReg = (Get-ItemProperty $edgePath -Name $name -ErrorAction Stop).$name

    if ($chromeReg -like "*$latestValue*" -and $edgeReg -like "*$latestValue*") {
        Write-Output "$name contains $latestValue in Chrome and Edge. Compliant"
        exit 0
    }
    else {
        Write-Output "$name does not contain $latestValue. Non-compliant"
        exit 1
    }
}
catch {
    Write-Output "$name does not contain $latestValue. Non-compliant"
    exit 1
}