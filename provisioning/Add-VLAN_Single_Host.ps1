$VC = Read-Host " Enter vCenter name:"
Connect-VIServer $VC  
$VMHosts = Get-VMHost -Name 192.168.21.108
foreach ($VMHost in $VMHosts) {
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "CasNet" -VLanId 0
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Citizen" -VLanId	3003
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "City Express" -VLanId	112
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Htrunk-LAN-Kumari" -VLanId	3207
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "ILO/IPMI/MGMT" -VLanId 2001
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Kumari-Card-Server" -VLanId 3208
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Kumari-Prod-Lan" -VLanId 3206
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Kumari-Pumori-Mahakali" -VLanId 3178
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Kumari-ksthmdp-Srv" -VLanId 3101
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Kumari_Test_Srv" -VLanId 334
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "MNepal-Pumori" -VLanId 3095
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Mercantile" -VLanId 29
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC-AppDev-Zone6" -VLanId 3056
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC-Application-Zone" -VLanId 3055
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC-Bank-vlan" -VLanId 3220
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC-Internalserver-zone3" -VLanId 3053
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC-ShareDB-Zone" -VLanId 3054
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC-ZONE-17" -VLanId 3063
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC-otherappDB-zone-11" -VLanId 3061
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NCC_IBanking_Zone15" -VLanId 3070
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NFS-LAN" -VLanId 2000
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NIC-ASIA-LAN" -VLanId 3004
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NIC-BPD" -VLanId 3020
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NIC-UAT" -VLanId 3021
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NIC-UAT-PRODUCTION" -VLanId 3025
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NICASIA-CBS" -VLanId 3022
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NIC_AUX_HO_155" -VLanId 155
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NIC_iSCSI" -VLanId 3116
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "NMB" -VLanId 3241
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Private" -VLanId 2004
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Public" -VLanId 2005
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Redhat_Cluster_Lan" -VLanId 3115
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SL-LAB" -VLanId 111
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SLNET" -VLanId 100
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SRBL-AUX-CounterBillApplication" -VLanId 3005
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SRBL-BLB-SERVER" -VLanId 3017
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SRBL-EKAGAJ-APP" -VLanId 3009
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SRBL-File-Server" -VLanId 3007
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SRBL-Legacy-CBS" -VLanId 3015
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SRBL-hTRUNK" -VLanId 3016
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "SRBL_EKAGAJ_DBnS" -VLanId 3099
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Sanima" -VLanId 3001
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Storage" -VLanId 2002
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Sunrise" -VLanId 3002
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "Sunrise-2" -VLanId 3018
Get-VMHost -name $VMhost | Get-VirtualSwitch -name vswitch0 | New-VirtualPortGroup -name "TestDevSRBL" -VLanId 333
}
Disconnect-viserver -Server $VC -Confirm:$false ‍
