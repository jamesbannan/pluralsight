# Modify for your environment
location="eastus"
RG_Name="SA-TEST-RG"
ASP_Name="SA-TEST-ASP"
Web_Name="SA-TEST-WEB-101"
ACR_Name="crftestacr"

#Create resources
az group create -n $RG_Name -l $location -o none
az acr create -n $ACR_Name --sku standard -g $RG_Name -l $location -o none
az appservice plan create --is-linux -n $ASP_Name --sku p1v2 -g $RG_Name -l $location -o none
az webapp create -n $Web_Name -g $RG_Name -p $ASP_Name -i "nginx" -o none

#List resources in the resource group
az resource list -g $RG_Name -o table

# STEP 1: Assign an identity to your WebApp
# Modify for your environment
Identity_ID=$(az webapp identity assign -g $RG_Name -n $Web_Name --query principalId --output tsv)

# Configure WebApp to use the Manage Identity Credentials to perform docker pull operations
Webapp_Config=$(az webapp show -g $RG_Name -n $Web_Name --query id --output tsv) + "/config/web"
az resource update --ids $Webapp_Config --set properties.acrUseManagedIdentityCreds=True -o none

# STEP 2: Grant access to the identity on ACR
# Modify for your environment
ACR_ID=$(az acr show -g $RG_Name -n $ACR_Name --query id --output tsv)

#ACR will allow the identity to perform pull operations and nothing more
az role assignment create --assignee $Identity_ID --scope $ACR_ID --role acrpull -o none

# Step 3: Configure WebApp to pull image:tag from ACR
# Modify for your environment
ACR_URL=$(az acr show -g $RG_Name --n $ACR_Name --query loginServer --output tsv)
Image="myapp:latest"
FX_Version="Docker|"$ACR_URL"/"$Image

#Configure the ACR, Image and Tag to pull
az resource update --ids $Webapp_Config --set properties.linuxFxVersion=$FX_Version -o none --force-string





