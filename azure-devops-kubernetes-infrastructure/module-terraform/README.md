# Deploy AKS Cluster with Advanced Networking using Hashicorp Terraform

This folder contains the assets needed to deploy an AKS Cluster in a Microsoft Azure subscription. The cluster is configured to use Container Networking Interface (CNI) or Advanced networking.

The assets are designed to support the module <em>Developing an AKS Deployment Template</em> in the Pluralsight course <strong>Manage Kubernetes Infrastructure</strong>.

The deployment steps are documented in the Bash scripts contained in the [scripts](scripts) folder. The scripts in this folder are not designed to be standalone assets, but rather to show a step-by-step process to demonstrate the processes for deploying a more complex AKS cluster solution.

The entire solution is designed to be deployed using [Hashicorp Terraform](https://www.terraform.io/). The solution will deploy:

- an Azure Resource Group
- a Virtual Network with dedicated subnet
- a Log Analytics workspace
- an Azure AD service principal and RBAC assignment
- an AKS cluster configured with Advanced networking and monitoring addon

The solution uses a [Terraform backend](https://www.terraform.io/docs/backends/types/azurerm.html) supported by an Azure Storage Account. This is deployed using the steps documented in the Bash script [createTfRemoteState.sh](scripts/createTfRemoteState.sh).

## Requirements

The script assumes that you are running a system with [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed. You should also have authenticated against an Azure environment using `az login` with credentials which have sufficient permissions in the Azure AD tenant to create new service principals and Owner permissions at the subscription scope. The environment also requires [Hashicorp Terraform](https://www.terraform.io/) - the demo was built and tested using Terraform v0.12.8.

The steps in the deployment script can be run on any system which support running Bash scripts: [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) on Windows 10, Linux or MacOS. You can also execute all the steps using an [Azure Cloud Shell](https://azure.microsoft.com/en-au/features/cloud-shell/) session, either directly via the Azure Portal, using the [Azure Account](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azure-account) extension in VSCode or using the new [Windows Terminal](https://github.com/microsoft/terminal).