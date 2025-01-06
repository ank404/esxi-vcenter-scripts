[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = "VM Report"
$msg   = "Enter VM Name you would like to get Report of:"
$VM = [Microsoft.VisualBasic.Interaction]::InputBox($msg,$title )

function get-vminventory
{
    $vcinfo = Import-Csv C:\Users\Anup.SL\Desktop\vcenter.csv
    foreach ($vi in $vcinfo)
    {
        $convi = Connect-VIServer -server $vi.viserver -username $vi.username -password $vi.password   
        $vms = Get-VM -Name $VM | Sort Name -descending:$false
        $vms | Select Name, PowerState, NumCpu, MemoryGB,           
            @{N="HardDiskSizeGB";E={[Math]::Round((Get-HardDisk -VM $_ | Measure-Object -Sum CapacityGB).Sum)}},
            @{N="IP Address";E={@($_.guest.IPAddress[0])}},
            @{N="VC-Server";E={ $convi.Name }},
            @{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},
            @{Label = "Guest OS" ; Expression = {$_.ExtensionData.Config.GuestFullName}}
        $discvi = disconnect-viserver -server * -force -confirm:$false
    }
}

get-vminventory | Export-Csv c:\Users\Anup.SL\Desktop\Report\VMReport.csv -NoTypeInformation

$file = "C:\Users\Anup.SL\Desktop\Report\VMReport.csv"
$csv= Import-Csv C:\Users\Anup.SL\Desktop\Report\VMReport.csv 
 $Numcpu = $csv.Numcpu | Measure-Object -Sum  
 $MemoryGB = $csv.MemoryGB | Measure-Object -Sum
 $HDD = $csv.HardDiskSizeGB | Measure-Object -Sum  
 $object = New-Object PSObject  
 $object | Add-Member -Name Name -Value "Total" -MemberType NoteProperty  
 $object | Add-Member -Name PowerState -Value "--" -MemberType NoteProperty
 $object | Add-Member -Name NumCpu -Value $Numcpu.sum -MemberType NoteProperty  
 $object | Add-Member -Name MemoryGB -Value $MemoryGB.sum -MemberType NoteProperty
 $object | Add-Member -Name HardDiskSizeGB -Value $HDD.sum -MemberType NoteProperty
 $object | Export-csv $file -Append -Force

 $options = @{
    'SmtpServer' = "mail.silverlining.com.np" 
    'To' = "<anup.khanal@silverlining.com.np>" 
    'From' = "VM Report <vmreport@silverlining.com.np>" 
    'Subject' = "VM Report" 
    'Body' = "Please find the VM Report attached within this mail." 
    'Attachments' = $file  
}

Send-MailMessage @options