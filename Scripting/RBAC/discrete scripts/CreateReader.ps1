param (
    [string]$newRoleName = $(throw "Please specify -newRoleName"),
    [string[]]$assignableScopes = $(throw "Please specify -assignableScopes")

)

### Default Actions for Reader ###
#
# */read
#
### End Default Actions ###

$baseRoleName = "Reader"

#Login
#TODO: Need to handle credential files, will currently prompt
Login-AzureRmAccount

#Get built-in role, modify, and save
#TODO: take new role name from cmd
$role = Get-AzureRmRoleDefinition $baseRoleName
$role.Id = $null
$role.Name = $newRoleName

#To clear default actions
#$role.Actions.Clear()

#Add actions
#$role.Actions.Add("Microsoft.Storage/*/read") #example

#Add assignable scopes

$role.AssignableScopes.Clear()

ForEach ($subscriptionId in $assignableScopes)
{

    $role.AssignableScopes.Add("/subscriptions/" + $subscriptionId)

}

#save as new role
New-AzureRmRoleDefinition -Role $role

