# settings
$defaultPath = [Environment]::GetFolderPath("MyDocuments") + "\subscriptions.csv"
#$csvDelimiter = ','
 
# set azure account
[void] (Login-AzureRmAccount)
 
# receive all subscriptions
$subscriptions = Get-AzureRmSubscription

# configure csv output
"Enter destination path - leave it empty to use $defaultPath"
$path = read-host
if([String]::IsNullOrWhiteSpace($path)) {
    $path = $defaultPath
}
 
<# add back in if we want to flag -NoClobber on export-csv
if (Test-Path $path) { 
    "File $path already exists. Delete? [y]/n"
    $remove = read-host
    if([String]::IsNullOrWhiteSpace($remove) -or $remove.ToLower().Equals('y')) {
        Remove-Item $path
    }
}
#>

#Write info to console
$subscriptions | ft SubscriptionId, SubscriptionName, State, TenantId

#Write info to csv
$subscriptions | export-csv $path -force -NoTypeInformation 
 
"Export done!"