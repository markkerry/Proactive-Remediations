<#
.SYNOPSIS
    Remediation script for a MEM Proactive Remediation.
.DESCRIPTION
    Sets the following as trusted sites in uBlock extension of Chrome and Edge

    pendo.io, semrush.com, app.creatopy.com, authentication.demandbase.com

    After adding a domain (i.e. pendo.io) to the $value variable. Update
    the $latestValue variable so the remediation can check if it exists
.NOTES
    FileName:   uBlock_Policy_Remediate.ps1
    Date:       10/01/2022
    Author:     Mark Kerry
#>

$chromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy"
$edgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\3rdparty\Extensions\odfafepnkmbhccpbejgmiehpchacaeak\policy"
$name = "adminSettings"
$type = "String"
$value = '{"autoUpdate":true,"netWhitelist":"about-scheme\nchrome-extension-scheme\nchrome-scheme\nmoz-extension-scheme\nopera-scheme\nedge-scheme\nvivaldi-scheme\nwyciwyg-scheme\npendo.io\nsemrush.com\n6sense.com\napp.creatopy.com\nauthentication.demandbase.com\nlightning.force.com"}'
# Update this variable everytime a new domain is added to the $value variable
$latestValue = "lightning.force.com"

# Chrome Policy
if (!(Test-Path -Path $chromePath)) {
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\" -Name "policy" -Force | Out-Null -ErrorAction Stop
        Set-ItemProperty -Path $chromePath -Name $name -Type $type -Value $value -Force -ErrorAction Stop
    }
    catch {
        Write-Output "Failed to change the $name $type for Chrome"
    }
}
else {
    $adminSettings = Get-ItemProperty $chromePath -Name $name -ErrorAction SilentlyContinue
    if (!($adminSettings.adminSettings -like "*$latestValue*")) {
        try {
            Set-ItemProperty -Path $chromePath -Name $name -Type $type -Value $value -Force -ErrorAction Stop
        }
        catch {
            Write-Output "Failed to change the $name $type for Chrome"
        }
    }
}

# Edge Policy
if (!(Test-Path -Path $edgePath)) {
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\3rdparty\Extensions\odfafepnkmbhccpbejgmiehpchacaeak\" -Name "policy" -Force | Out-Null -ErrorAction Stop
        Set-ItemProperty -Path $edgePath -Name $name -Type $type -Value $value -Force -ErrorAction Stop
    }
    catch {
        Write-Output "Failed to change the $name $type for Edge"
    }
}
else {
    $adminSettings = Get-ItemProperty $edgePath -Name $name -ErrorAction SilentlyContinue
    if (!($adminSettings.adminSettings -like "*$latestValue*")) {
        try {
            Set-ItemProperty -Path $edgePath -Name $name -Type $type -Value $value -Force -ErrorAction Stop
        }
        catch {
            Write-Output "Failed to change the $name $type for Edge"
        }
    }
}