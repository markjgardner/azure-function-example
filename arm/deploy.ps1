param(
  [Parameter(Mandatory=$true)]
  $subscriptionId,
  [Parameter(Mandatory=$true)]
  $resourceGroup,
  [String]
  $templatePath = ".\template.json",
  [HashTable]
  $parameters = @{}
)


$sub = Select-AzureRmSubscription -Subscription $subscriptionId
New-AzureRmResourceGroupDeployment -Name "ArmDeployment" -ResourceGroupName $resourceGroup -TemplateFile $templatePath -TemplateParameterObject $parameters
