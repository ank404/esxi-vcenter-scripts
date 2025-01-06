$VC = Read-Host " Enter vCenter name:"
Connect-VIServer $VC 
&{foreach($esx in Get-VMHost){
    $vNicTab = @{}
    $esx.ExtensionData.Config.Network.Vnic | %{
        $vNicTab.Add($_.Portgroup,$_)
    }
    foreach($vsw in (Get-VirtualSwitch -VMHost $esx)){
        foreach($pg in (Get-VirtualPortGroup -VirtualSwitch $vsw)){
            Select -InputObject $pg -Property @{N="ESX";E={$esx.name}},
                @{N="vSwitch";E={$vsw.Name}},
                @{N="VLANname";E={$pg.Name}},
                @{N="VLANid";E={$pg.VLanId}}
        }
    }
}} | Export-Csv c:\Users\Anup.SL\Desktop\report.csv -NoTypeInformation -UseCulture