# Description: This script will generate a CSV file with the list of VMs created in the last 14 days.

# Connect to the vCenter
connect-viserver -server 'vCenter IP/Domain' -username 'Username' -password 'Enter Password Here'

# Get the list of VMs created in the last 14 days
Get-VIEvent -maxsamples 10000 -Start (Get-Date).AddDays(–14) |
where {$_.Gettype().Name-eq "VmCreatedEvent" -or $_.Gettype().Name-eq "VmBeingClonedEvent" -or $_.Gettype().Name-eq "VmBeingDeployedEvent"} |
Sort CreatedTime -Descending |
Select CreatedTime, UserName,FullformattedMessage, @{ Name="CPU"; Expression={(Get-VM -Name $_.Vm.Name).NumCPU}}, @{ Name="MemoryGB"; Expression={(Get-VM -Name $_.Vm.Name).MemoryGB}} |

# Export the list of VMs to a CSV file
export-csv PATH_TO_CSV_FILE\VMsCreated.csv -nti