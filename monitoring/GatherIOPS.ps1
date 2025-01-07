param($datastores, $numsamples)

$server = "vCenter Server IP/Domain"
# connect vCenter server session
Connect-VIServer $server -username 'username' -password 'Enter Password Here' | Out-Null

# function to get iops for a vm on a particular host
function GetAvgStat($vmhost,$vm,$ds,$samples,$stat){
	# number of samples = x time
	# 180 = 60min
	# 90 = 30min
	# 45 = 15min
	# 15 = 5min
	# 3 = 1min
	# 1 = 20sec (.33 min)

	# connect to host
	connect-viserver -server $vmhost -credential $credentials -NotDefault -WarningAction SilentlyContinue | Out-Null
	
	# identify device id for datastore
	$myDatastoreID = ((Get-Datastore $ds -server $vmhost) | Get-View).info.vmfs.extent[0].diskname
	
	# gather iops generated by vm
	$rawVMStats = get-stat -entity	(get-vm $vm -server $vmhost) -stat $stat -maxSamples $samples
	$results = @()
	
	foreach ($stat in $rawVMStats) {
		if ($stat.instance.Equals($myDatastoreID)) {
			$results += $stat.Value
		}
	}
	
	$totalIOPS = 0
	foreach ($res in $results) {
		$totalIOPS += $res	
	}
	
	return [int] ($totalIOPS/$samples/20)
}

$IOPSReport = @()

foreach ($datastore in $datastores) {

  # Grab datastore and find VMs on that datastore
  $myDatastore = Get-Datastore -Name $datastore -server $server
  $myVMs = Get-VM -Datastore $myDatastore -server $server | Where {$_.PowerState -eq "PoweredOn"}
  
  # Gather current IO snapshot for each VM
  $dataArray = @()
  foreach ($vm in $myVMs) {
  	$data = �� | Select "VM", "Interval (minutes)", "Avg Write IOPS", "Avg Read IOPS"
  	$data."VM" = $vm.name
  	$data."Interval (minutes)" = ($numsamples*20)/60
  	$data."Avg Write IOPS" = GetAvgStat -vmhost $vm.host.name -vm $vm.name -ds $datastore -samples $numsamples -stat disk.numberWrite.summation
  	$data."Avg Read IOPS" = GetAvgStat -vmhost $vm.host.name -vm $vm.name -ds $datastore -samples $numsamples -stat disk.numberRead.summation
  	$dataArray += $data
  }
  
  # Do something with the array of data
  $IOPSReport += $dataArray

}

$IOPSReport
$IOPSReport | Export-CSV Path_to_CSV_File -NoType