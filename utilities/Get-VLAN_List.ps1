# Description: This script will generate a report of all VLANs configured on all ESXi hosts in a vCenter Server.

# Import the required modules
# This script will prompt the user to enter the vCenter name.
$VC = Read-Host " Enter vCenter name:"
Connect-VIServer $VC 

# Generate the report
&{foreach($esx in Get-VMHost){
    $vNicTab = @{}
    $esx.ExtensionData.Config.Network.Vnic | %{
        $vNicTab.Add($_.Portgroup,$_)
    }
    # Get the VLANs configured on the ESXi host
    # This will give the ESXi host name, vSwitch name, VLAN name, and VLAN ID
    # The report will be saved in a CSV file
    foreach($vsw in (Get-VirtualSwitch -VMHost $esx)){
        foreach($pg in (Get-VirtualPortGroup -VirtualSwitch $vsw)){
            Select -InputObject $pg -Property @{N="ESX";E={$esx.name}},
                @{N="vSwitch";E={$vsw.Name}},
                @{N="VLANname";E={$pg.Name}},
                @{N="VLANid";E={$pg.VLanId}}
        }
    }
}} | Export-Csv PATH_TO_CSV_FILE\report.csv -NoTypeInformation -UseCulture