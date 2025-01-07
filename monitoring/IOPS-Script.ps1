connect-viserver -server vCenter_Server -username 'Username' -password 'Enter Password Here'

$metrics = "disk.numberwrite.summation","disk.numberread.summation"
$start = (Get-Date).AddMinutes(-5)
$report = @()
$vms = Get-VM | where {$_.PowerState -eq "PoweredOn"}
$stats = Get-Stat -Realtime -Stat $metrics -Entity $vms -Start $start
$interval = $stats[0].IntervalSecs

$lunTab = @{}
foreach($ds in (Get-Datastore -VM $vms | where {$_.Type -eq "VMFS"})){
  $ds.ExtensionData.Info.Vmfs.Extent | %{
    $lunTab[$_.DiskName] = $ds.Name
  }
}

$report = $stats | Group-Object -Property {$_.Entity.Name},Instance | %{
  $readStat = $_.Group |
    where{$_.MetricId -eq "disk.numberread.summation"} |
    Measure-Object -Property Value -Average -Maximum
  $writeStat = $_.Group |
    where{$_.MetricId -eq "disk.numberwrite.summation"} |
    Measure-Object -Property Value -Average -Maximum
  New-Object PSObject -Property @{
    VM = $_.Values[0]
    IOPSWriteMax = [math]::Round($writeStat.Maximum/$interval,0)
    IOPSWriteAvg = [math]::Round($writeStat.Average/$interval,0)
    IOPSReadMax = [math]::Round($readStat.Maximum/$interval,0)
    IOPSReadAvg = [math]::Round($readStat.Average/$interval,0)
    Datastore = $lunTab[$_.Values[1]]
  }
}

Send-MailMessage -Subject "IOPS Report" -From iops@example.com `
  -To admin@example.com -SmtpServer smtp.example.com `
  -BodyAsHtml -Body ($report | Select VM,Datastore,IOPSWriteAvg,IOPSWriteMax,IOPSReadAvg,IOPSReadMax | Sort-Object -Property IOPSWriteAvg -Descending | Export-Csv Path_to_CSV_File\IOPS.csv -NoTypeInformation | ConvertTo-Html | Out-String)