<#
.SYNOPSIS
    Creates a virtual port group on a specific vSwitch across multiple hosts in a cluster.

.DESCRIPTION
    This script connects to multiple vCenter servers using credentials provided in a CSV file.
    It retrieves all hosts from a specified cluster and creates a new virtual port group on
    a specific vSwitch for each host.

.PARAMETER CSVPath
    Path to the CSV file containing vCenter server details (viserver, username, password).

.NOTES
    The CSV file should be in the following format:
    viserver,username,password
    vcenter1,admin,password
    vcenter2,admin,password
    vcenter3,admin,password

    Ensure VMware PowerCLI is installed before running the script.

.EXAMPLE
    .\Create-VirtualPortGroup.ps1 -CSVPath "C:\path\to\cred.csv"

    This command reads vCenter credentials from the specified CSV file and creates a virtual
    port group on all hosts in the specified cluster.
#>

# Import the CSV file containing vCenter server credentials
$vcinfo = Import-Csv C:\path\to\cred.csv

# Loop through each vCenter server in the CSV
    foreach ($vi in $vcinfo) {
        # Connect to the vCenter server
        $convi = Connect-VIServer -server $vi.viserver -username $vi.username -password $vi.password
    }
    
    # Get all hosts in the specified cluster
    $Hosts = Get-cluster -Name "Cluster Name" | Get-VMHost

    # Loop through each host and create the virtual port group
    foreach ($H in $Hosts){
        # Retrieve the vSwitch on the host
        $vSwitch = Get-VirtualSwitch -VMHost $H -Name "vSwitch0"

        # Create a new virtual port group on the vSwitch
        $vPortG = New-VirtualPortGroup -VirtualSwitch $vSwitch -Name "VLAN_NAME" -VLanId xxxx -Confirm
    }