[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = "VM Report"
$msg   = "Enter VM Name you would like to get Report of:"
$VM = [Microsoft.VisualBasic.Interaction]::InputBox($msg,$title )

function get-report 
{
    $vcinfo = Import-Csv C:\Users\Anup.SL\Desktop\vcenter.csv
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
get-report | ConvertTo-Html -Property Name, NumCpu, MemoryGB, CPUUsageAverageMhz, MemoryUsageAverage%, NetworkUsageAverageKBps, DiskUsageAverageKBps -Head $Header | Out-File "C:\Users\Anup.SL\Desktop\Report\GIBL-Monthly-Report.html" 