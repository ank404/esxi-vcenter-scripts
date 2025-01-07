# Description: This script is used to generate a report of a VM in a vCenter server.

# Import the required modules
# This script will prompt the user to enter the VM name for which the report is required.
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = "VM Report"
$msg   = "Enter VM Name you would like to get Report of:"
$VM = [Microsoft.VisualBasic.Interaction]::InputBox($msg,$title )

# Connect to the vCenter
function get-vminventory
{
    $vcinfo = Import-Csv PATH_TO_Vcenter_Details\vcenter.csv
    foreach ($vi in $vcinfo)
    {
        $convi = Connect-VIServer -server $vi.viserver -username $vi.username -password $vi.password   

        # Get the VM details. It will give the VM name, power state, number of CPUs, memory, hard disk size, IP address, vCenter server, datastore, and guest OS.
        $vms = Get-VM -Name $VM | Sort Name -descending:$false
        $vms | Select Name, PowerState, NumCpu, MemoryGB,        
            @{N="HardDiskSizeGB";E={[Math]::Round((Get-HardDisk -VM $_ | Measure-Object -Sum CapacityGB).Sum)}},
            @{N="IP Address";E={@($_.guest.IPAddress[0])}},
            @{N="VC-Server";E={ $convi.Name }},
            @{N="Datastore";E={[string]::Join(',',(Get-Datastore -Id $_.DatastoreIdList | Select -ExpandProperty Name))}},
            @{Label = "Guest OS" ; Expression = {$_.ExtensionData.Config.GuestFullName}}
            # Disconnect from the vCenter server
            $discvi = disconnect-viserver -server * -force -confirm:$false
    }
}

# Generate the report and save it to a CSV file
get-vminventory | Export-Csv PATH_TO_CSV_FILE\VMReport.csv -NoTypeInformation

# Generate the report and send it as an email
$file = "PATH_TO_CSV_FILE\VMReport.csv"

# Calculate the total number of CPUs, memory, and hard disk size
# This will give the total number of CPUs, memory, and hard disk size of all the VMs in the report
$csv= Import-Csv PATH_TO_FINAL_REPORT\VMReport.csv 
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

 # Send the report as an email with CSV file as attachment
 $options = @{
    'SmtpServer' = "smtp.example.com" 
    'To' = "<admin@example.com>" 
    'From' = "VM Report <vmreport@example.com>" 
    'Subject' = "VM Report" 
    'Body' = "Please find the VM Report attached within this mail." 
    'Attachments' = $file  
}

Send-MailMessage @options