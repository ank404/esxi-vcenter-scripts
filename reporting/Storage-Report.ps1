Param (
    [Alias("Host")]
    [string]$PathToReport = "C:\Users\Anup.SL\Desktop\Report",
    [string]$To = "anup.khanal@silverlining.com.np",
    [string]$From = "'ACE Travels Storage Report' <report@silverlining.com.np>",
    [string]$SMTPServer = "mail.silverlining.com.np"
)

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

Function Percentcal {
    param(
    [parameter(Mandatory = $true)]
    [int]$InputNum1,
    [parameter(Mandatory = $true)]
    [int]$InputNum2)
    $InputNum1 / $InputNum2*100
}

#endregion

$Header = @"
<head>
<title>Monthly Report For ACE Travels</title>
<style>
body { font-family: "Trebuchet MS", Arial, Helvetica, sans-serif; font-size: 14px;}
table { font-family: "Trebuchet MS", Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%;}
th { padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #4CAF50; color: white;}
TR:Hover TD {Background-Color: #9bfd9c;}
.odd  { background-color:#ffffff; }
.even { background-color:#dddddd; }
</style></body></head>
"@

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = "VM Report"
$msg   = "Enter VM Name you would like to get Report of:"
$VM = [Microsoft.VisualBasic.Interaction]::InputBox($msg,$title )

    $vcinfo = Import-Csv C:\Users\Anup.SL\Desktop\vcenter.csv
    foreach ($vi in $vcinfo)
     {
        $convi = Connect-VIServer -server $vi.viserver -username $vi.username -password $vi.password
        $vms = Get-VM -Name $VM | Get-VMGuest -PipelineVariable guest |
        where{$_.Disks -ne $null} |
        ForEach-Object -Process {
        $_.Disks | ForEach-Object -Process {
        New-Object PSObject -Property ([ordered]@{
            VM = $guest.VM.Name
            Path = $_.Path
            CapacityGB = [math]::round($_.CapacityGB)
            FreeSpaceGB = [math]::round($_.FreeSpaceGB)
            Percent = [int]($_.FreeSpaceGB/$_.CapacityGB * 100)  
            })
          }
        }
      }

$Report = @($vms | Select VM, Path, CapacityGB, FreeSpaceGB, Percent)  | sort VM -Descending:$true
#################################################################################
######################### HTML Body #############################################
#################################################################################
$html1 = "<body><h2 style = text-align:center>ACE Travels Monthly OS Storage Report</h2>
    <p><b>Legend</b><br/>
    <b><font color=#ffff24>Yellow</font></b> = Used percentage between 75% and 85%<br/>
    <b><font color=red>Red</font></b> = Used percentage between 85% and 100%
    </p></body>"
$html2 = "<b></B>"
$html3 = "<TABLE>`n<TR><TH>VM Name</TH><TH>Path</TH><TH>Capacity (GB)</TH><TH>FreeSpace (GB)</TH><TH>Percent Free%</TH></TR>"
$html4 = foreach ($dStore in $Report) {

## create the row STYLE HTML based on this datastore's PercentFree value 
$strRowStyleHTML10 = if ($dStore.Percent -lt 15){" STYLE='background-color: #ff2424'"}
                     elseif ($dStore.Percent -lt 25) {" STYLE='background-color: #ffff24'"}
                     else {" STYLE='background-color: #cfe9f8'"}

## return the HTML for the row for this datastore 
"<TR$strRowStyleHTML10><TD>$($dStore.VM)</TD><TD>$($dStore.Path)</TD><TD>$($dStore.CapacityGB)</TD><TD>$($dStore.FreeSpaceGB)</TD><TD>$($dStore.Percent)</TD></TR>`n"

} ## end foreach
$html5 = "</TABLE>"
#################################################################################

$Report = ConvertTo-Html -Body $Header$html1$html2$html3$html4$html5 | Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd

$Report | Out-File $PathToReport\storage.html

$MailSplat = @{
    To         = $To
    From       = $From
    Subject    = "ACE Travels Monthly Report"
    Body       = ($Report | Out-String)
    BodyAsHTML = $true
    SMTPServer  = $SMTPServer
}

Send-MailMessage @MailSplat