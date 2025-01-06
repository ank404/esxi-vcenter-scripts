$vcinfo = Import-Csv C:\Users\Anup.SL\Desktop\cred.csv
foreach ($vi in $vcinfo)
    {
$convi = Connect-VIServer -server $vi.viserver -username $vi.username -password $vi.password
}
$Hosts = Get-cluster -Name "SLDC-Cluster" | Get-VMHost

foreach ($H in $Hosts){

    $vSwitch = Get-VirtualSwitch -VMHost $H -Name "vSwitch0"

    $vPortG = New-VirtualPortGroup -VirtualSwitch $vSwitch -Name "WL-Public-Internal-2291-vlan" -VLanId 2291 -Confirm

}