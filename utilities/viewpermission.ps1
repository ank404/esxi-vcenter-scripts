$VC = Read-Host " Enter vCenter name:"
Connect-VIServer $VC

$si = Get-View ServiceInstance -Server $global:DefaultVIServer

$authMgr = Get-View -Id $si.Content.AuthorizationManager-Server $global:DefaultVIServer

$authMgr.RetrieveAllPermissions() |

Select @{N='Entity';E={Get-View -Id $_.Entity -Property Name -Server $global:DefaultVIServer | select -ExpandProperty Name}},

    @{N='Entity Type';E={$_.Entity.Type}},

    Principal,

    Propagate,

    @{N='Role';E={$perm = $_; ($authMgr.RoleList | where{$_.RoleId -eq $perm.RoleId}).Info.Label}} |

    Export-Csv c:\Users\Anup.SL\Desktop\Report\permission.csv -NoTypeInformation