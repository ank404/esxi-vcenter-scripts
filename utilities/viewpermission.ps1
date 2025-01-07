# Description: This script will generate a report of all permissions in a vCenter Server.


# Import the required modules
# This script will prompt the user to enter the vCenter name.
$VC = Read-Host " Enter vCenter name:"
# Connect to the vCenter
Connect-VIServer $VC

# Get the list of permissions
$si = Get-View ServiceInstance -Server $global:DefaultVIServer
$authMgr = Get-View -Id $si.Content.AuthorizationManager-Server $global:DefaultVIServer

# This will give the entity, entity type, principal, propagate, and role of the permissions
$authMgr.RetrieveAllPermissions() |

# Export the list of permissions to a CSV file
Select @{N='Entity';E={Get-View -Id $_.Entity -Property Name -Server $global:DefaultVIServer | select -ExpandProperty Name}},

    @{N='Entity Type';E={$_.Entity.Type}},

    Principal,

    Propagate,

    @{N='Role';E={$perm = $_; ($authMgr.RoleList | where{$_.RoleId -eq $perm.RoleId}).Info.Label}} |

    Export-Csv PATH_TO_CSV_FILE\permission.csv -NoTypeInformation