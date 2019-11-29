### Register Azure VM as IoT Edge device

### Define variables
RESOURCE_GROUP=${1}
IOT_HUB=${2}
VM_NAME=${3}

### Get resources
hub=$(az iot hub show --name ${IOT_HUB})
vm=$(az vm show --resource-group ${RESOURCE_GROUP} --name ${VM_NAME})

### Register VM as IoT Edge device
registration=$(az iot hub device-identity create --hub-name ${IOT_HUB} --device-id ${VM_NAME} --edge-enabled)
connectionString=$(az iot hub device-identity show-connection-string --hub-name ${IOT_HUB} --device-id ${VM_NAME})
deviceString=$(echo $connectionString | jq .connectionString -r)

### Add connection string to VM
az vm run-command invoke \
--resource-group ${RESOURCE_GROUP} \
--name ${VM_NAME} \
--command-id RunShellScript \
--script "/etc/iotedge/configedge.sh \'${deviceString}\''"