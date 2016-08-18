# parse params [app name], [uri], [cert store location]
param (
    [string]$appName = "jofultzApp5", #$(throw "Please specify -appName"),
    [string]$uri = "https://www.jofultz5.org", #$(throw "Please specify -uri"),
    [string] $certStore = "cert:\CurrentUser\My",  #defaulting to CurrentUser, but will not want it in this location for service execution
    [string] $assignedScope = "a03d98a2-7ef5-4fb2-8a94-f2980f7d50a1" #defaulting to Darren's to ease debug
)

#to use the same principal on another machine, the cert will have to exported from the
#machine on which it was created and imported on the target machine 

#must login manually to perform the rest of the script
Login-AzureRmAccount -SubscriptionId $assignedScope

$appName = "CN=" +$appName

#create self-signed certificate
#for a real-world scenario, this will require an authority issued cert installed in the preferred
# location (e.g., root)
$cert = New-SelfSignedCertificate -CertStoreLocation $certStore -Subject $appName -KeySpec KeyExchange


#fetch just the keyvalue
$keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())


#create AD App with key value
$azureAdApplication = New-AzureRmADApplication -DisplayName $appName -HomePage $uri -IdentifierUris $uri -KeyValue $keyValue -KeyType AsymmetricX509Cert -EndDate $cert.NotAfter -StartDate $cert.NotBefore      

#compensating transaction for my testing
#Remove-AzureRmADApplication -ApplicationObjectId "[id]"

$azureAdApplication

#create service principal for application
New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId

#the principal is created asynchronously, just going to wait
Start-Sleep -s 10

#add Owner role to service principal so it can be used going forward for provisioning
#the -Scope argument for New-AzureRmRoleAssignment expects the format "/subscriptions/<id>"
$subscriptionString =  "/subscriptions/" +$assignedScope 

New-AzureRmRoleAssignment -RoleDefinitionName Owner -ServicePrincipalName $azureAdApplication.ApplicationId.Guid -Scope $subscriptionString


# 72f988bf-86f1-41af-91ab-2d7cd011db47
# darren sub ID: a03d98a2-7ef5-4fb2-8a94-f2980f7d50a1