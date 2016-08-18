#/// create credential

$User = "jofultz@microsoft.com"
$PWord = ConvertTo-SecureString -String "July2016P@55word" -AsPlainText -Force
$PSCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord


#/// login to subscription

#TODO: Move this to a cmd line param

$SubscriptionName = "Brust - Microsoft Azure Internal Consumption"

Login-AzureRmAccount -Credential $PSCredential -SubscriptionName $SubscriptionName

#run script