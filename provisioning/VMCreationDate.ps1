connect-viserver -server sldc-vc.sl -username noc -password 1SLktm@noc3

Get-VIEvent -maxsamples 10000 -Start (Get-Date).AddDays(–14) |
where {$_.Gettype().Name-eq "VmCreatedEvent" -or $_.Gettype().Name-eq "VmBeingClonedEvent" -or $_.Gettype().Name-eq "VmBeingDeployedEvent"} |
Sort CreatedTime -Descending |
Select CreatedTime, UserName,FullformattedMessage, @{ Name="CPU"; Expression={(Get-VM -Name $_.Vm.Name).NumCPU}}, @{ Name="MemoryGB"; Expression={(Get-VM -Name $_.Vm.Name).MemoryGB}} |
export-csv c:\Users\Anup.SL\Desktop\VMsCreated.csv -nti