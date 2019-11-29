# Create Resource Group
groupName='ps-aml'
groupLocation='Australia East'
group=$(az group create --name ${groupName} --location "${groupLocation}" --verbose)

# Deploy Azure Machine Learning Service Workspace
templatePath='../aml'
templateFile="${templatePath}/azureDeploy.json"

timestamp=$(date -u +%FT%TZ | tr -dc '[:alnum:]\n\r')
name="$(echo $group | jq .name -r)-${timestamp}"
deployment=$(az group deployment create \
      --resource-group $(echo $group | jq .name -r) \
      --name ${name} \
      --template-file ${templateFile} \
      --verbose \
      )
