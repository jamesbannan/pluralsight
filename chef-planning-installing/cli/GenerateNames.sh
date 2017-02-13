#!/bin/bash

# https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-azure-resource-manager/

function randompass () {
        local randompassLength
        if [ $1 ]; then
                randompassLength=$1
        else
                randompassLength=8
        fi

        pass=</dev/urandom tr -dc a-z0-9 | head -c $randompassLength
        echo $pass
}

randomString=`randompass 6`

azureResourceStorageName="chefstorage$randomString"
azurePublicDNSName="chef-lab-$randomString"

echo "newStorageAccountName is equal to \"$azureResourceStorageName\""
echo "dnsNameForPublicIP is equal to \"$azurePublicDNSName\""
echo "Please update these values in the azuredeploy.parameters.json file"
