# Description: This script is used to generate a monthly report of VMs in Average CPU, Memory, Network, and Disk Utilization.

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = "VM Report"
$msg   = "Enter VM Name you would like to get Report of:"
$VM = [Microsoft.VisualBasic.Interaction]::InputBox($msg,$title )

# When asked to get Report you should use * as VM Name. e.g. client1* will give you report of all VMs starting with client1

# Connect to the vCenter
# CSV File should be in below Format
        # viserver,username,password
        # vcenter1,admin,password
        # vcenter2,admin,password
function get-report 
{
    $vcinfo = Import-Csv PATH_TO_CSV_FILE\vcenter.csv
    # Loop through the vCenter information and get the report
    foreach ($vi in $vcinfo)
     {
        $convi = Connect-VIServer -server $vi.viserver -username $vi.username -password $vi.password   
            $vms = Get-VM -Name $VM | Where-Object -Property Powerstate -eq "PoweredOn" | Sort Name -descending:$false  
            $vms | Select Name, NumCpu, MemoryGB,
            @{N="CPUUsageAverageMhz" ; E={[Math]::Round((($_ | Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddDays(-30) -IntervalMins 120 | Measure-Object Value -Average).Average),2)}},
            @{N="MemoryUsageAverage%" ; E={[Math]::Round((($_ | Get-Stat -Stat mem.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 120 | Measure-Object Value -Average).Average),2)}},
            @{N="NetworkUsageAverageKBps" ; E={[Math]::Round((($_ | Get-Stat -Stat net.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 120 | Measure-Object Value -Average).Average),2)}},
            @{N="DiskUsageAverageKBps" ; E={[Math]::Round((($_ | Get-Stat -Stat disk.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 120 | Measure-Object Value -Average).Average),2)}}
     }
}

# Generate the report and save it to an HTML file
$Header = @"
<!DOCTYPE html>
<head>
<title>Monthly Utilization Report For GIBL</title>
<style>
body { font-family: "Trebuchet MS", Arial, Helvetica, sans-serif; font-size: 14px;}
table { font-family: "Trebuchet MS", Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%;}
th { padding-top: 12px; padding-bottom: 12px; text-align: left; background-color: #4CAF50; color: white;}
.odd  { background-color:#ffffff; }
.even { background-color:#dddddd; }
</style></body></head>
"@

# Get the report and convert it to HTML
get-report | ConvertTo-Html -Property Name, NumCpu, MemoryGB, CPUUsageAverageMhz, MemoryUsageAverage%, NetworkUsageAverageKBps, DiskUsageAverageKBps -Head $Header | Out-File "PATH_TO_HTML_FILE\Monthly-Report.html"