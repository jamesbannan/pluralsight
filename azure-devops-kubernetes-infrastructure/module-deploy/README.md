# Deploy basic AKS Cluster with Azure CLI

This folder contains the assets needed to deploy a basic AKS Cluster in a Microsoft Azure subscription.

The assets are designed to support the module <em>Deploying Azure Kubernetes Service</em> in the Pluralsight course <strong>Manage Kubernetes Infrastructure</strong>.

The deployment steps are documented in the Bash script [deployAks.sh](scripts/deployAks.sh). This script is not designed to be a standalone asset, but rather a step-by-step process to show some of the various options for deploying a simple AKS cluster.

This demo also uses an ARM template to deploy a Log Analytics workspace in the solution Resource Group for AKS cluster monitoring. Azure CLI can do this automatically for you, but in this case you relinquish control over configuration options such as the workspace name. The ARM template is located in the [arm/logAnalytics](arm/logAnalytics) folder.

## Requirements

The script assumes that you are running a system with [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed. You should also have authenticated against an Azure environment using `az login` with credentials which have sufficient permissions in the Azure AD tenant to create new service principals and Owner permissions at the subscription scope.

The steps in the deployment script can be run on any system which support running Bash scripts: [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) on Windows 10, Linux or MacOS. You can also execute all the steps using an [Azure Cloud Shell](https://azure.microsoft.com/en-au/features/cloud-shell/) session, either directly via the Azure Portal, using the [Azure Account](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azure-account) extension in VSCode or using the new [Windows Terminal](https://github.com/microsoft/terminal).