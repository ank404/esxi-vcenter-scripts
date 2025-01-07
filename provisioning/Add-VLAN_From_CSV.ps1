# Description: This script will add VLANs to the vSwitches in the cluster based on the input CSV file

# Connect to the vCenter
$VC = Read-Host " Enter vCenter name:"
Connect-VIServer $VC

# Input CSV file
$InputFile = "PATH_TO_CSV_FILE\VLAN_LIST.csv"

# CSV File should be in below Format
# vSwitch,VLANname,VLANid
# vSwitch1,VLAN1,100
# vSwitch1,VLAN2,200
# vSwitch2,VLAN3,300

# Import the CSV file
$MyVLANFile = Import-CSV $InputFile

# Loop through the CSV file and add the VLANs to the vSwitches
ForEach ($VLAN in $MyVLANFile) {
        $MyvSwitch = $VLAN.vSwitch
        $MyVLANname = $VLAN.VLANname
        $MyVLANid = $VLAN.VLANid

        # If you want to add the VLANs to specific hosts, you can use the below command
        #$MyVMHosts = Get-VMHost -Name xx.xx.xx.xx (IP Address of the host)

        # Query the cluster to retrieve the hosts
        $MyVMHosts = Get-cluster -Name "Cluster_NAME" | Get-VMHost

        # Loop through the hosts and add the virtual port group to our vswitch based on the input
        ForEach ($VMHost in $MyVMHosts) {
        Get-VirtualSwitch -VMHost $VMHost -Name $MyvSwitch | New-VirtualPortGroup -Name $MyVLANname -VLanId $MyVLANid
        }
} 