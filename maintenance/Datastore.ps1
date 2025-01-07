<#
.SYNOPSIS
    Generates a datastore usage report for a vCenter Server and sends it via email.

.DESCRIPTION
    This script connects to a vCenter Server, retrieves datastore details, calculates
    usage metrics, formats the data into an HTML report, and sends it via email.

.PARAMETER VIServer
    The vCenter Server address.

.PARAMETER PathToReport
    The local path where the HTML report will be saved.

.PARAMETER To
    The email address to send the report to.

.PARAMETER From
    The sender email address.

.PARAMETER SMTPServer
    The SMTP server used to send the email.

.EXAMPLE
    .\Datastore.ps1 -VIServer "my-vcenter" -PathToReport "C:\Reports" -To "admin@example.com" -From "no-reply@example.com" -SMTPServer "smtp.example.com"

.NOTES
    Ensure VMware PowerCLI is installed and properly configured.
#>

Param (
    [Alias("Host")]
    [string]$VIServer = "vCenter Server",
    [string]$PathToReport = "Path TO REPORT",
   
    [string]$To = "admin@example.com",
    [string]$From = "'Storage' <datastore@example.com>",
    [string]$SMTPServer = "smtp.example.com"
)

# Function to apply alternating CSS classes to HTML table rows
Function Set-AlternatingRows {
    [CmdletBinding()]
         Param(
             [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
             [object[]]$HTMLDocument,
     
             [Parameter(Mandatory=$True)]
             [string]$CSSEvenClass,
     
             [Parameter(Mandatory=$True)]
             [string]$CSSOddClass
         )
     Begin {
         $ClassName = $CSSEvenClass
     }
     Process {
         [string]$Line = $HTMLDocument
         $Line = $Line.Replace("<tr>","<tr class=""$ClassName"">")
         If ($ClassName -eq $CSSEvenClass)
         {    $ClassName = $CSSOddClass
         }
         Else
         {    $ClassName = $CSSEvenClass
         }
         $Line = $Line.Replace("<table>","<table width=""90%"">")
         Return $Line
     }
}

# Function to calculate percentages
Function Percentcal {
    param(
    [parameter(Mandatory = $true)]
    [int]$InputNum1,
    [parameter(Mandatory = $true)]
    [int]$InputNum2)
    $InputNum1 / $InputNum2*100
}

#endregion

$date = get-date -uformat "%d-%m-%Y"

# Check and import PowerCLI module
If (-not (Get-Module –ListAvailable VM* | Import-Module -ErrorAction SilentlyContinue))
{   Try { Get-Module –ListAvailable VM* | Import-Module -ErrorAction Stop }
    Catch { Throw "Problem loading VMware.VimAutomation.Core snapin because ""$($Error[1])""" }
}

# Connect to vCenter Server
Try {
    $Conn = Connect-VIServer $VIServer -user noc -Password 1SLktm@noc3
}
Catch {
    Throw "Error connecting to $VIServer because ""$($Error[1])"""
}

# HTML Header for the report
$Header = @"
<style>
BODY{font-family: Arial; font-size: 10pt;}
TABLE {border-width: 1px; border-spacing:20px; margin-left:auto;margin-right:auto; padding:2px; border-style: solid;border-color: black;border-collapse: collapse;}
TR:Hover TD {Background-Color: #C1D5F8;}
TH {border-width: 1px; padding: 5px; border-style: solid; border-color: black;background-color: #dddddd;}
TD {border-width: 1px;padding: 4px;border-style: solid;border-color: black;}
.odd  { background-color:#ffffff; }
.even { background-color:#dddddd; }
</style>
<title>
Datastore Report - $VIServer
</title>
"@

# Fetch datastores excluding certain patterns
$datastores = Get-Datastore | sort name | Where-Object {$_.Name -notlike "Synergy-ENC*"} | Where-Object {$_.Name -notlike "SynergyPalo*"} | Where-Object {$_.Name -notlike "DR-ESXI*"} | Where-Object {$_.Name -notlike "appesxi*"}

# Process each datastore and calculate metrics
ForEach ($ds in $datastores) {
    $PercentFree = Percentcal $ds.FreeSpaceMB $ds.CapacityMB
       
    $PercentFree = “{0:N4}” -f $PercentFree
    $ds | Add-Member -type NoteProperty -name DataStoreName -value $ds
    $ts =  $ds.ExtensionData.Summary.Capacity/1GB
    $ts = “{0:N2}” -f $ts
    $ds | Add-Member -type NoteProperty -name TotalSpaceGB -value $ts
	$ps = ($ds.ExtensionData.Summary.Capacity – $ds.ExtensionData.Summary.FreeSpace + $ds.ExtensionData.Summary.Uncommitted)/1GB
	$ps = “{0:N2}” -f $ps
	$ds | Add-Member -type NoteProperty -name ProvisionedGB -value $ps
	$op = ($ds.ExtensionData.Summary.Uncommitted – $ds.ExtensionData.Summary.FreeSpace)/1GB
	$op = “{0:N0}” -f $op
	$ds | Add-Member -type NoteProperty -name OverProvisionedGB -value $op
	$opp = ($ds.ExtensionData.Summary.Uncommitted - $ds.ExtensionData.Summary.FreeSpace)/1GB
	$oppv = if($opp -gt 0){"True"} else {"False"}
	$ds | Add-Member -type NoteProperty -name OverProvisioned -value $oppv
    $us = ($ds.ExtensionData.Summary.Capacity – $ds.ExtensionData.Summary.FreeSpace)/1GB
    $us = “{0:N2}” -f $us
    $ds | Add-Member -type NoteProperty -name ActualUsedSpaceGB -value $us
	$fs = ($ds.ExtensionData.Summary.FreeSpace)/1GB
	$fs = “{0:N2}” -f $fs
	$ds | Add-Member -type NoteProperty -name FreeSpace -value $fs
    $ds | Add-Member -type NoteProperty -name PercentFree -value $PercentFree
}

# Generate report and format HTML
$Report = @($datastores | Select DataStoreName, TotalSpaceGB, ProvisionedGB, OverProvisionedGB, OverProvisioned, ActualUsedSpaceGB, FreeSpace, PercentFree)  | sort OverProvisioned -Descending:$true
#################################################################################
######################### HTML Body #############################################
#################################################################################
$html1 = "<body><h2 style = text-align:center>SLDC Synergy Report as on $date</h2>
    <p><b>Legend</b><br/><br/>
    <b><font color=green>Green</font></b> = Used percentage between 0% and 75%<br/>
    <b><font color=yellow>Yellow</font></b> = Used percentage between 75% and 85%<br/>
    <b><font color=red>Red</font></b> = Used percentage between 85% and 100%
    </p></body>"
$html2 = "<b></B>"
$html3 = "<TABLE CELLSPACING=4 CELLPADDING=2 BORDER=5>`n<TR><TH>Datastore Name</TH><TH>Capacity (GB)</TH><TH>Provisioned (GB)</TH><TH>OverProvisioned (GB)</TH><TH>OverProvisioned </TH><TH>UsedSpace (GB)</TH><TH>FreeSpace (GB)</TH><TH>Percent Free</TH></TR>"
$html4 = foreach ($dStore in $Report) {

## create the row STYLE HTML based on this datastore's PercentFree value 
$strRowStyleHTML10 = if ($dStore.PercentFree -lt 15 -And $dStore.OverProvisioned -eq "True") {" STYLE='background-color: red'"}
                     elseif ($dStore.PercentFree -lt 25 -And $dStore.OverProvisioned -eq "True") {" STYLE='background-color: #F0FF00'"}
                     else {" STYLE='background-color: LightGreen'"}

## return the HTML for the row for this datastore 
"<TR$strRowStyleHTML10><TD>$($dStore.DataStoreName)</TD><TD>$($dStore.TotalSpaceGB)</TD><TD>$($dStore.ProvisionedGB)</TD><TD>$($dStore.OverProvisionedGB)</TD><TD>$($dStore.OverProvisioned)</TD><TD>$($dStore.ActualUsedSpaceGB)</TD><TD>$($dStore.FreeSpace)</TD><TD>$($dStore.PercentFree)</TD></TR>`n"

} ## end foreach
$html5 = "</TABLE>"

#################################################################################

$Report = ConvertTo-Html -Body $Header$html1$html2$html3$html4$html5 | Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd

# Save the report to file
$Report | Out-File $PathToReport\Datastore_Report_Vcenter.html

# Email the report
$MailSplat = @{
    To         = $To
    From       = $From
    Subject    = "$VIServer Datastore Report"
    Body       = ($Report | Out-String)
    BodyAsHTML = $true
   SMTPServer = $SMTPServer
}

Send-MailMessage @MailSplat