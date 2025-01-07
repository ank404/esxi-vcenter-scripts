#Import VMware modulde
Get-Module -Name VMware* -ListAvailable | Import-Module
 
#Connect to our vCenter Server using the logged in credentials
Connect-VIServer synergy.sl -User 'noc' -Password '1SLktm@noc3'
 
$head = @'
<style>
body { background-color:#FFFFFF;
       font-family:calibri;
       font-size:11pt; }
td, th { border:1px solid black; 
         border-collapse:collapse; }
th { color:white;
     background-color:black; }
table, tr, td, th { padding: 2px; margin: 0px }
table { margin-left:50px; }
</style>
'@
$Output = Get-VMHost | Sort-Object -Property Name
$body = $Output | select Name,Parent,ConnectionState,@{N="Uptime(Days)"; E={New-Timespan -Start $_.ExtensionData.Summary.Runtime.BootTime -End (Get-Date) | Select -ExpandProperty Days}} | ConvertTo-Html -PreContent "<h1>ESXi Availability Report:- $D</h1>" | foreach {if ($_ -like "*<td>Maintenance</td>*"){$_ -replace "<tr>","<tr bgcolor=yellow>"} elseif($_ -notlike "*<td>Connected</td>*"){$_ -replace "<tr>","<tr bgcolor=red>"}else{$_} } | Out-String
$body1 = Get-Cluster | Select @{N="Cluster Name";E={Get-Cluster -Name $_}}, @{N="ESXi Host Count"; E={($_ | Get-VMHost).Count} },@{N="VM Count"; E={($_ | Get-VM).Count}} | ConvertTo-Html -PreContent "<h2>ESXi & VM Count in vCenter: </h2>" | Out-String
$finalout = ConvertTo-HTML -head $head -PostContent $body,$body1 | Out-String
 
#Send email to Admins
Send-MailMessage -From 'vcenter-alert@silverlining.com.np' -To 'anup.khanal@silverlining.com.np' -Subject 'Host Health Check' -body "$finalout" -BodyAsHtml -SmtpServer 'mail.silverlining.com.np'

#DisConnect from our vCenter Server
disconnect-viserver -confirm:$false