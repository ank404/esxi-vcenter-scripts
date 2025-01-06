$VC = Read-Host " Enter vCenter name:"
Connect-VIServer $VC

# Set the input file
$InputFile = "C:\Users\Anup.SL\Desktop\report.csv"

# Read the import file
$MyVLANFile = Import-CSV $InputFile

# Parse the input file and add the virtual port groups accordingly
ForEach ($VLAN in $MyVLANFile) {
        $MyvSwitch = $VLAN.vSwitch
        $MyVLANname = $VLAN.VLANname
        $MyVLANid = $VLAN.VLANid

        # Query the cluster to retrieve the hosts
        #$MyVMHosts = Get-VMHost -Name 192.168.21.66
        $MyVMHosts = Get-cluster -Name "SLDC-Cluster" | Get-VMHost

        # Loop through the hosts and add the virtual port group to our vswitch based on the input
        ForEach ($VMHost in $MyVMHosts) {
        Get-VirtualSwitch -VMHost $VMHost -Name $MyvSwitch | New-VirtualPortGroup -Name $MyVLANname -VLanId $MyVLANid
        }
} 