﻿<#
.SYNOPSIS
    A script to connect to vCenter Server and perform compute-related tasks.

.DESCRIPTION
    This script connects to a vCenter Server using credentials and performs operations
    such as generating and styling HTML content related to compute resources.

.PARAMETER vCenterServer
    The name or IP address of the vCenter Server.

.PARAMETER Username
    The username for vCenter Server authentication.

.PARAMETER Password
    The password for vCenter Server authentication.

.NOTES
    Ensure VMware PowerCLI is installed before running the script.

#>
# Connect to vCenter using passthrough credentials
# SECURITY WARNING: Using hardcoded credentials is not recommended. Replace this with secure handling, such as prompting for credentials or using a credential store.

# Connect to vCenter using passthrough credentials
connect-viserver -server 'vCenter Server' -username 'username' -password 'Enter password here'

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
        # Initialize the class to be applied for even rows
         $ClassName = $CSSEvenClass
     }
     Process {
        # Replace table row tags with appropriate class attributes
         [string]$Line = $HTMLDocument
         $Line = $Line.Replace("<tr>","<tr class=""$ClassName"">")
         If ($ClassName -eq $CSSEvenClass)
         {    $ClassName = $CSSOddClass
         }
         Else
         {    $ClassName = $CSSEvenClass
         }
         # Adjust the table width for better readability
         $Line = $Line.Replace("<table>","<table width=""90%"">")
         Return $Line
     }
}

# Get the current date in the format dd-mm-yyyy
$date = get-date -uformat "%d-%m-%Y"

# Retrieve a list of all hosts in a specific cluster
# Note: To retrieve all hosts across clusters, omit the `get-cluster` command and use `get-vmhost` directly.
$hosts = get-vmhost; 

# Define an empty table to store host details
$table = @() 

# Loop through each host and calculate CPU usage statistics
foreach ($vmhost in $hosts) {

    # Create an empty row for host statistics
    $row = "" | select Hostname, pCPUsAvailable, CPUsAssigned, Ratio, Overcommited;

    # Get the number of vCPUs assigned to this host
    $cpumeasure = $vmhost | get-vm | where {$_.powerstate -eq "poweredon"} | measure-object numcpu -sum;

    # Add the hostname to the row
    $row.Hostname = (($vmhost.name));

    # Add the number of logical CPUs to the row 
    $row.pcpusavailable = $vmhost.numcpu;

    # Add the number of allocated vCPUs to the row
    $row.cpusassigned = [int]$cpumeasure.sum;

    # Add the Ratio of pCPU and vCPU
    $row.ratio = [double]($cpumeasure.sum / $row.pcpusavailable);
    $row.Ratio = "{0:N0}:1" -f $row.Ratio

    # Get the overcommitment level as a percentage
    $perc = [int](($cpumeasure.sum / $row.pcpusavailable)*100);

    # Warn if overcommitted
    if ($perc -gt 100) {
        $row.Overcommited = "YES - " + $perc + "%";
    }
    else {
        $row.Overcommited = "No";
    }


# Add the current row to the table
$table = $table + $row 
}

# Apply alternating row styles to the HTML table
$Header = @"
<style>
BODY{background-color:white;}
TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;foreground-color: black;background-color: LightBlue}
TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black;}
TR:Hover TD {Background-Color: #C1D5F8;}
.odd  { background-color:#ffffff; }
.even { background-color:#dddddd; }
</style>
<title>
SLDC Compute Resource Report
</title>
"@

$html1 = "<body><h2 style = text-align:center>SLDC Synergy Compute Report as on $date</h2>
    <p><b> Ratio over 4 are highlighted in Yellow Colour</b><br/>
    <h3> CPU OverCommited </h3>
    </p></body>"
$html2 = "<b></B>"
$html3 = "<TABLE CELLSPACING=4 CELLPADDING=2 BORDER=5>`n<TR><TH>HostName</TH><TH>pCPUs Available</TH><TH>vCPUs Assigned</TH><TH>Ratio</TH><TH>OverCommited</TH></TR>"
$html4 = foreach ($row in $table) {
$strRowStyleHTML10 = if ($row.ratio -lt 4) {" STYLE='background-color: white'"}
                     else {" STYLE='background-color: #F0FF00'"}

"<TR$strRowStyleHTML10><TD>$($row.Hostname)</TD><TD>$($row.pCPUsAvailable)</TD><TD>$($row.CPUsAssigned)</TD><TD>$($row.Ratio)</TD><TD>$($row.Overcommited)</TD></TR>`n"
} 
$html5 = "</TABLE>"

$table = ConvertTo-Html -Body $Header$html1$html2$html3$html4$html5 | Sort HostName -Descending:$false | Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd

$table | Out-File C:\Users\Anup.SL\Desktop\Report\SLDC-Compute.html

Get-Cluster -PipelineVariable cluster |
  ForEach-Object -Process {

   $reportMem = @()

   Get-VMHost -PipelineVariable esx | 

   ForEach-Object -Process {
   
   $vMem = get-vm -location $esx | where { $_.PowerState -match "on" } | measure-object -property MemoryGB -SUM | Select -Expandproperty Sum

   $reportMem += $esx | Select Name, @{N = 'Memory Available'; E = { [Math]::Round($_.MemoryTotalGB) } },

   @{N = 'VMemory Assigned'; E = {[Math]::Round( $vMem) } },

   @{N = 'Ratio'; E = { [math]::Round(100 * ($vMem / $_.MemoryTotalGB)) } },

   @{N = 'OverCommited'; E = { [Math]::Round(100 * (($vMem - $_.MemoryTotalGB) / $_.MemoryTotalGB), 1) } },
   
   @{N='Commited';E={ $script:a = [Math]::Round(100 * (($vMem - $_.MemoryTotalGB) / $_.MemoryTotalGB), 1) 
	
   if($a -gt 0){"True"} 
	
   else {"False"}}}

 }

}
   
$html = @"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html><head>
<style>"
BODY{background-color:white;}
TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;foreground-color: black;background-color: LightBlue}
TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black;foreground-color: black;background-color: white}
</style>

</head><body>
"@
$table += "<h3>Memory Overcommited</h3>"
$table += $reportMem | Sort Name -Descending:$false | ConvertTo-Html -Fragment
$table += @"
</body>
</html>
"@

# Send the report via email (optional - configure SMTP settings before using)
$MailSplat = @{
    To         = "admin@example.com"
    From       = "'Compute Report' reports@example.com"
    Subject    = "Compute Report"
    Body       = ($table | Out-String)
    BodyAsHTML = $true
   SMTPServer = "smtp.example.com"
}

Send-MailMessage @MailSplat